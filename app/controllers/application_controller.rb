class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def home
  end

  def current_user
    @current_user ||= ActiveRecord::Base.connection.execute("SELECT * FROM users WHERE email='#{session[:user]}'").first
  end
end
