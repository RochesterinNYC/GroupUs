require 'groupme_interface'
require 'groupme_analyzer'

class Group < ActiveRecord::Base

  validates :group_id, presence: true, uniqueness: true
  validates :groupme_updated, presence: true 

  def self.find_or_create_by_group_id access_token, group_id
    @group = self.find_or_create_by(group_id: group_id)
    if @group.groupme_updated.blank?
      @group.synchronize_actual_updated @group.actual_updated_at(access_token)
    end
    @group
  end

  def get_group_name access_token
    target_group = ::GroupMeInterface.get_group access_token, self.group_id
    target_group['name']
  end

  def actual_updated_at access_token
    target_group = ::GroupMeInterface.get_group access_token, self.group_id
    target_group['updated_at']
  end

  def cache_up_to_date actual_update_time
    self.groupme_updated == actual_update_time
  end

  #deletes the cache for the group because it is outdated
  def delete_cache access_token
    Rails.cache.delete("messages#{self.group_id}")
    Rails.cache.delete("results#{self.group_id}")
    self.synchronize_actual_updated actual_updated_at(access_token)
  end 

  def synchronize_actual_updated actual_update_time
    self.groupme_updated = actual_update_time
    self.save!
  end

  def get_messages access_token, num_messages
    @messages = Rails.cache.fetch("messages#{self.group_id}") { ::GroupMeInterface.get_all_messages access_token, self.group_id, num_messages }
  end

  def get_results messages
    @results = Rails.cache.fetch("results#{self.group_id}") { ::GroupMeAnalyzer.analyze_group messages }
  end

end
