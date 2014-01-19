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

  def format_time time
    time_string = ""
    if time == 0
      time_string = "12 AM - 1 AM"
    elsif time >= 1 && time < 12
      time_string = "#{time} AM - #{time + 1} AM"
    elsif time == 12
      time_string = "12 PM - 1 PM"
    elsif time >= 13
      time_string = "#{time - 12} PM - #{time - 11} PM"
    end
    time_string
  end
  helper_method :format_time

  def format_times times
    time_array = Array.new
    times.each do |time|
      time_array << format_time(time)
    end
    time_array
  end
  helper_method :format_times

  def get_cutoff users, cutoff_index
    users.count <= cutoff_index ? 0 : users[cutoff_index][1]
  end
  helper_method :get_cutoff

end
