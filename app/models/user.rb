require 'groupme_interface'

class User < ActiveRecord::Base

  validates :groupme_uid, presence: true, uniqueness: true

  def self.find_or_create_by_token(access_token)
    user_info = ::GroupMeInterface.get_user_info(access_token)
    groupme_id = user_info['id']

    user = self.find_or_create_by(groupme_uid: groupme_id)
    if user.groupme_updated != user_info['updated_at']
      user.attributes = { name: user_info['name'], phone_number: user_info['phone_number'], image_url: user_info['image_url'], email: user_info['email'], sms_enabled: user_info['sms'], access_token: access_token, groupme_updated: user_info['updated_at'] }
      user.save
    end
    user
  end

end