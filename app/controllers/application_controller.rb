class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_user
    if current_user
      return true
    end
    gflash :error => "Please login with GroupMe."
    redirect_to login_path
  end

  def format_user_names name_array
    names = ""
    last_name = name_array.last
    name_array.each do |name|
      name == last_name ? names += name : names += name + "/"
    end
    names
  end
  helper_method :format_user_names

end
