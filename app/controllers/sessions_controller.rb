class SessionsController < ApplicationController
  skip_before_filter :require_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_or_create_by_token(params[:access_token])
    session[:user_id] = user.id
    render :text => session[:user_id]
    #redirect_to root_path, notice: "Logged in as #{user.name}"
  end

  def failure
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to login_path
  end
end
