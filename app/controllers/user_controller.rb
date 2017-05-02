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
    @user = ActiveRecord::Base.connection.execute("SELECT * FROM users WHERE id=#{params[:id].to_i}").first
    @projects = ActiveRecord::Base.connection.execute("SELECT * FROM projects WHERE id IN (SELECT projects.id FROM projects INNER JOIN pledges ON projects.id = pledges.project_id WHERE pledges.user_id=#{params[:id].to_i})")
    @comments = ActiveRecord::Base.connection.execute("SELECT projects.title, reviews.comment, reviews.created_at FROM reviews INNER JOIN projects ON reviews.project_id = projects.id WHERE reviews.type='comment' AND reviews.user_id=#{params[:id].to_i}")
    @is_following = (ActiveRecord::Base.connection.execute("SELECT * FROM followers WHERE following_id=#{params[:id].to_i} AND follower_id=#{current_user['id'].to_i}") || []).count >= 1
  end

  def backed
    @user = ActiveRecord::Base.connection.execute("SELECT * FROM users WHERE id=#{params[:id].to_i}").first
    @projects = ActiveRecord::Base.connection.execute("SELECT * FROM projects WHERE id IN (SELECT projects.id FROM projects INNER JOIN pledges ON projects.id = pledges.project_id WHERE pledges.user_id=#{params[:id]})")
    @comments = ActiveRecord::Base.connection.execute("SELECT projects.title, reviews.comment, reviews.created_at FROM reviews INNER JOIN projects ON reviews.project_id = projects.id WHERE reviews.type='comment' AND reviews.user_id=#{params[:id].to_i}")
    @is_following = (ActiveRecord::Base.connection.execute("SELECT * FROM followers WHERE following_id=#{params[:id].to_i} AND follower_id=#{current_user['id'].to_i}") || []).count >= 1
  end

  def comments
    @user = ActiveRecord::Base.connection.execute("SELECT * FROM users WHERE id=#{params[:id].to_i}").first
    @projects = ActiveRecord::Base.connection.execute("SELECT * FROM projects WHERE id IN (SELECT projects.id FROM projects INNER JOIN pledges ON projects.id = pledges.project_id WHERE pledges.user_id=#{params[:id]})")
    @comments = ActiveRecord::Base.connection.execute("SELECT projects.title, reviews.comment, reviews.created_at FROM reviews INNER JOIN projects ON reviews.project_id = projects.id WHERE reviews.type='comment' AND reviews.user_id=#{params['id'].to_i}")
    @is_following = (ActiveRecord::Base.connection.execute("SELECT * FROM followers WHERE following_id=#{params[:id].to_i} AND follower_id=#{current_user['id'].to_i}") || []).count >= 1
  end

  def credit_cards

  end
end
