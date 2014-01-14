class SessionsController < ApplicationController
  skip_before_filter :require_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_or_create_by_token(params[:access_token])
    session[:user_id] = user.id
    gflash :success => "Logged in as #{current_user.name}"
    redirect_to root_path
  end

  def failure
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to login_path
  end
end
