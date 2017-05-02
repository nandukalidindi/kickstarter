class LoginController < ApplicationController

  def login
  end

  def authenticate
    email = params[:email]
    password = params[:password]

    count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM users where email='#{email}' AND password='#{password}'").first["count"]

    if count == "1"
      redirect_to '/home'
      session[:user] = email
      @current_user ||= ActiveRecord::Base.connection.execute("SELECT * FROM users WHERE email='#{session[:user]}'").first
    else
      redirect_to '/', alert: 'The email address and password you entered do not match.'
    end
  end

  def signup

  end

  def create_user
    full_name = params[:name].rpartition(" ")
    username = params[:username]
    email = params[:email]
    redirect_to '/signup', alert: 'Email do not match' if params[:email] != params[:email_confirm]
    password = params[:password]
    redirect_to '/signup', alert: 'Password do not match' if params[:password] != params[:password_confirm]
    ActiveRecord::Base.connection.execute("INSERT INTO users(first_name, last_name, username, email, password) VALUES ('#{full_name[0]}', '#{full_name[2]}', '#{username}', '#{email}', '#{password}')")
    redirect_to '/', notice: true
  end
end
