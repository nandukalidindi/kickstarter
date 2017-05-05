class UserController < ApplicationController

  before_action :deep_munge_empty_strings, only: [:update_profile]

  def show
    binding.pry
  end

  def new
  end

  def index
  end

  def account
    @user = ActiveRecord::Base.connection.execute("SELECT * FROM users where id=#{params[:id].to_i}").first
  end

  def reset_password
    current_password = ActiveRecord::Base.connection.execute("SELECT password FROM users WHERE id=#{params[:id].to_i}").first['password']

    if current_password != params['current_password']
      redirect_to "/users/#{params[:id]}/account", alert: "PASSWORD IS INCORRECT. SYSTEM WILL SELF DESTRUCT IN 10 mins"
      return
    end

    if params[:password] == params[:confirm_password] && params[:password].length != 0
      ActiveRecord::Base.connection.execute("
        UPDATE users
        SET password='#{params['password']}',
            email='#{params['email']}'
        WHERE id=#{params[:id].to_i}
      ")
      redirect_to "/users/#{params[:id]}/account", notice: "PASSWORD RESET SUCCESSFULLY!"
      return
    end
    redirect_to "/users/#{params[:id]}/account"
  end

  def followers
    @followers = ActiveRecord::Base.connection.execute("SELECT * FROM followers INNER JOIN users ON followers.follower_id = users.id WHERE followers.following_id=#{params[:id].to_i}").to_a
    @followers.each do |follower|
      ar_follower = User.find(follower['id'].to_i)
      unless ar_follower.profile_image_file_name.nil?
        follower['profile_image'] = ar_follower.profile_image.url
      end
    end


    @following = ActiveRecord::Base.connection.execute("SELECT * FROM followers INNER JOIN users ON followers.following_id = users.id WHERE followers.follower_id=#{params[:id].to_i}").to_a
    @backed = ActiveRecord::Base.connection.execute("SELECT DISTINCT(project_id) FROM pledges WHERE user_id=#{params[:id].to_i}")
  end

  def following
    @followers = ActiveRecord::Base.connection.execute("SELECT * FROM followers INNER JOIN users ON followers.follower_id = users.id WHERE followers.following_id=#{params[:id].to_i}")
    @following = ActiveRecord::Base.connection.execute("SELECT * FROM followers INNER JOIN users ON followers.following_id = users.id WHERE followers.follower_id=#{params[:id].to_i}").to_a
    @following.each do |following|
      ar_following = User.find(following['id'].to_i)
      unless ar_following.profile_image_file_name.nil?
        following['profile_image'] = ar_following.profile_image.url
      end
    end
    @backed = ActiveRecord::Base.connection.execute("SELECT DISTINCT(project_id) FROM pledges WHERE user_id=#{params[:id].to_i}")
  end

  def profile
    @user = User.find(params[:id])
  end

  def update_profile
    ActiveRecord::Base.connection.execute("
    UPDATE users
    SET first_name=#{ActiveRecord::Base.sanitize(params['first_name'])},
        last_name=#{ActiveRecord::Base.sanitize(params['last_name'])},
        username=#{ActiveRecord::Base.sanitize(params['username'])},
        profile_image_url=#{ActiveRecord::Base.sanitize(params['profile_image_url'])},
        biography=#{ActiveRecord::Base.sanitize(params['biography'])},
        address=#{ActiveRecord::Base.sanitize(params['address'])},
        state=#{ActiveRecord::Base.sanitize(params['state'])},
        country=#{ActiveRecord::Base.sanitize(params['country'])},
        pincode=#{ActiveRecord::Base.sanitize(params['pincode'])}
    WHERE id=#{params[:id].to_i}
    ")

    if params[:profile_image]
      user = User.find(params[:id].to_i)
      user.profile_image = params[:profile_image]
      user.save!
    end

    redirect_to "/users/#{params[:id]}/profile"
  end

  def projects
    user_projects_sql = "SELECT projects.id, projects.title, projects.description, projects.maximum_fund, projects.search_thumbnail_small, projects.search_thumbnail_large, projects.video_url, users.first_name, users.last_name, projects.location, EXTRACT(EPOCH FROM (projects.end_date - CURRENT_TIMESTAMP))/(60*60*24) AS days_left , pledge_sums.pledge_sum
                FROM projects
                FULL OUTER JOIN (
                SELECT projects.id AS id, SUM(pledges.amount) AS pledge_sum
                FROM projects
                INNER JOIN pledges
                ON projects.id = pledges.project_id
                GROUP BY projects.id
                ) AS pledge_sums
                ON projects.id = pledge_sums.id
                INNER JOIN users
                ON users.id = projects.posted_by
                WHERE projects.posted_by=#{params[:id]}"

    projects = ActiveRecord::Base.connection.execute(user_projects_sql).to_a
    projects.each do |project|
      ar_project = Project.find(project['id'].to_i)
      unless ar_project.project_image_file_name.nil?
        project['project_image_url'] = ar_project.project_image.url
      end
    end

    @projects = [[], [], [], [], [], [], []]

    projects.each_with_index do |project, index|
      @projects[index/4] << project
    end
  end

  def recommendations
    recommend_sql = "SELECT projects.id, projects.title, projects.description, projects.maximum_fund, projects.search_thumbnail_small, projects.search_thumbnail_large, projects.video_url, users.first_name, users.last_name, projects.location, EXTRACT(EPOCH FROM (projects.end_date - CURRENT_TIMESTAMP))/(60*60*24) AS days_left , CASE WHEN pledge_sums.pledge_sum is null THEN 0 ELSE pledge_sums.pledge_sum END
                FROM projects
                FULL OUTER JOIN (
                SELECT projects.id AS id, SUM(pledges.amount) AS pledge_sum
                FROM projects
                INNER JOIN pledges
                ON projects.id = pledges.project_id
                GROUP BY projects.id
                ) AS pledge_sums
                ON projects.id = pledge_sums.id
                INNER JOIN users
                ON users.id = projects.posted_by
                WHERE projects.id IN
                (
                  SELECT project_id
                  FROM (
                          SELECT project_id, COUNT(*) AS no_of_views
                          FROM events
                          WHERE user_id=#{current_user['id']}
                          AND type='project_views'
                          GROUP BY project_id ORDER BY no_of_views DESC
                        ) AS A
                ) ORDER BY random() limit 6"

    @recommendations = ActiveRecord::Base.connection.execute(recommend_sql).to_a

    @recommendations.each do |project|
      ar_project = Project.find(project['id'].to_i)
      unless ar_project.project_image_file_name.nil?
        project['project_image_url'] = ar_project.project_image.url
      end
    end
  end

  def about
    ActiveRecord::Base.connection.execute("INSERT INTO events (user_id, profile_id, type, created_at, updated_at) VALUES (#{current_user['id']}, #{params[:id]}, 'profile_views', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    @user = User.find(params[:id].to_i)
    @projects = ActiveRecord::Base.connection.execute("SELECT * FROM projects WHERE id IN (SELECT projects.id FROM projects INNER JOIN pledges ON projects.id = pledges.project_id WHERE pledges.user_id=#{params[:id].to_i})")
    @comments = ActiveRecord::Base.connection.execute("SELECT projects.title, reviews.comment, reviews.created_at FROM reviews INNER JOIN projects ON reviews.project_id = projects.id WHERE reviews.type='comment' AND reviews.user_id=#{params[:id].to_i}")
    @is_following = (ActiveRecord::Base.connection.execute("SELECT * FROM followers WHERE following_id=#{params[:id].to_i} AND follower_id=#{current_user['id'].to_i}") || []).count >= 1
  end

  def backed
    @user = User.find(params[:id].to_i)
    @projects = ActiveRecord::Base.connection.execute("SELECT * FROM projects WHERE id IN (SELECT projects.id FROM projects INNER JOIN pledges ON projects.id = pledges.project_id WHERE pledges.user_id=#{params[:id]})").to_a
    @projects.each do |project|
      ar_project = Project.find(project['id'].to_i)
      unless ar_project.project_image_file_name.nil?
        project['project_image_url'] = ar_project.project_image.url
      end
    end
    @comments = ActiveRecord::Base.connection.execute("SELECT projects.title, reviews.comment, reviews.created_at FROM reviews INNER JOIN projects ON reviews.project_id = projects.id WHERE reviews.type='comment' AND reviews.user_id=#{params[:id].to_i}")
    @is_following = (ActiveRecord::Base.connection.execute("SELECT * FROM followers WHERE following_id=#{params[:id].to_i} AND follower_id=#{current_user['id'].to_i}") || []).count >= 1
  end

  def comments
    @user = User.find(params[:id].to_i)
    @projects = ActiveRecord::Base.connection.execute("SELECT * FROM projects WHERE id IN (SELECT projects.id FROM projects INNER JOIN pledges ON projects.id = pledges.project_id WHERE pledges.user_id=#{params[:id]})")
    @comments = ActiveRecord::Base.connection.execute("SELECT projects.title, reviews.comment, reviews.created_at FROM reviews INNER JOIN projects ON reviews.project_id = projects.id WHERE reviews.type='comment' AND reviews.user_id=#{params['id'].to_i}")
    @is_following = (ActiveRecord::Base.connection.execute("SELECT * FROM followers WHERE following_id=#{params[:id].to_i} AND follower_id=#{current_user['id'].to_i}") || []).count >= 1
  end

  def credit_cards
    @credit_cards = ActiveRecord::Base.connection.execute("SELECT * FROM credit_cards where user_id = #{current_user['id'].to_i}")
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

  def deep_munge_empty_strings
    params.keys.each do |x|
      params[x] = nil if params[x] == ""
    end
  end
end
