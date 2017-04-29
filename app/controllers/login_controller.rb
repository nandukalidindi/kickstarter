class LoginController < ApplicationController

  def login
    
  end

  def authenticate
    email = params[:email]
    password = params[:password]

    count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM users where email='#{email}' AND password='#{password}'").first["count"]

    if count == "1"
      redirect_to '/'
    else
      redirect_to '/login', alert: 'The email address and password you entered do not match.'
    end
  end

  def signup

  end

  def create_user
  end
end
