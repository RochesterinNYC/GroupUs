class GroupsController < ApplicationController

  before_filter :get_group, only: [:show, :messages]

  def index
    @groups = current_user.get_all_groups current_user.access_token
  end

  def show
    @name = @group.get_group_name current_user.access_token
    @messages = @group.get_messages current_user.access_token, params[:num_messages].to_i
    @results = @group.get_results @messages
    @words = @results[:word_frequency]
    @users = @results[:user_frequency]
    @times = @results[:time_frequency]
    #@months = 
  end

  def messages
    @name = @group.get_group_name current_user.access_token
    if params[:ascending] == 'true'
      @messages = @group.get_messages(current_user.access_token, params[:num_messages].to_i).reverse!
    else
      @messages = @group.get_messages current_user.access_token, params[:num_messages].to_i
    end
    @flip = !(params[:ascending] == 'true')
  end

  protected
  def get_group
    @group = Group.find_or_create_by_group_id current_user.access_token, params[:group_id]
    @group.delete_cache(current_user.access_token) if !@group.cache_up_to_date @group.actual_updated_at(current_user.access_token)
  end

end
