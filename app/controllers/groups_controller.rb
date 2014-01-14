require 'groupme_interface'

class GroupsController < ApplicationController
  def index
    @groups = ::GroupMeInterface.get_groups(current_user.access_token)
  end

  def show

  end

end
