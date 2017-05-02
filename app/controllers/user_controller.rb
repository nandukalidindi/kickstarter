class UserController < ApplicationController
  def show
    binding.pry
  end

  def new
  end

  def index
  end

  def followers
    @followers = ActiveRecord::Base.connection.execute("SELECT * FROM followers INNER JOIN users ON followers.follower_id = users.id WHERE followers.following_id=#{params[:id].to_i}")
    @following = ActiveRecord::Base.connection.execute("SELECT * FROM followers INNER JOIN users ON followers.following_id = users.id WHERE followers.follower_id=#{params[:id].to_i}")
    @backed = ActiveRecord::Base.connection.execute("SELECT DISTINCT(project_id) FROM pledges WHERE user_id=#{params[:id].to_i}")
  end

  def following
    @followers = ActiveRecord::Base.connection.execute("SELECT * FROM followers INNER JOIN users ON followers.follower_id = users.id WHERE followers.following_id=#{params[:id].to_i}")
    @following = ActiveRecord::Base.connection.execute("SELECT * FROM followers INNER JOIN users ON followers.following_id = users.id WHERE followers.follower_id=#{params[:id].to_i}")
    @backed = ActiveRecord::Base.connection.execute("SELECT DISTINCT(project_id) FROM pledges WHERE user_id=#{params[:id].to_i}")
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

  def follow
    follower_id = current_user['id'].to_i
    to_be_followed = params[:id].to_i
    count = ActiveRecord::Base.connection.execute("SELECT * FROM followers WHERE following_id=#{to_be_followed} AND follower_id=#{follower_id}").count
    if count < 1
      ActiveRecord::Base.connection.execute("INSERT INTO followers (follower_id, following_id, created_at, updated_at) VALUES (#{follower_id}, #{to_be_followed}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    end
    redirect_to :back
  end

  def unfollow
    follower_id = current_user['id'].to_i
    to_be_unfollowed = params[:id].to_i

    ActiveRecord::Base.connection.execute("DELETE FROM followers WHERE follower_id=#{follower_id} AND following_id=#{to_be_unfollowed}")
    redirect_to :back
  end
end
