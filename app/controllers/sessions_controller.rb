class SessionsController < ApplicationController
  skip_before_filter :require_user, only: [:new, :create]

  def new
    if current_user
      gflash :success => "You are already logged in with GroupMe."
      redirect_to groups_path
    end
  end

  def create
    user = User.find_or_create_by_token(params[:access_token])
    session[:user_id] = user.id
    gflash :success => "Logged in as #{current_user.name}"
    redirect_to groups_path
  end

  def destroy
    if current_user
      gflash :success => "You have successfully logged out."
    end
    session[:user_id] = nil    
    redirect_to login_path
  end
end
