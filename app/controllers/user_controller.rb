class UserController < ApplicationController
  def show
    binding.pry
  end

  def new
  end

  def index
  end

  def followers
  end

  def following
  end

  def profile
  end

  def about

  end

  def backed
    @projects = ActiveRecord::Base.connection.execute("SELECT * FROM projects WHERE id IN (SELECT projects.id FROM projects INNER JOIN pledges ON projects.id = pledges.project_id WHERE pledges.user_id=#{params[:id]})")
  end

  def comments
  end

  def credit_cards

  end
end
