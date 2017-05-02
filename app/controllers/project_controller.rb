class ProjectController < ApplicationController

  def index
    projects = ActiveRecord::Base.connection.execute('SELECT * FROM projects')
    index_sql = "SELECT projects.id, projects.title, projects.description, projects.maximum_fund, projects.search_thumbnail_small, projects.search_thumbnail_large, projects.video_url, users.first_name, users.last_name, projects.location, EXTRACT(EPOCH FROM (projects.end_date - CURRENT_TIMESTAMP))/(60*60*24) AS days_left , pledge_sums.pledge_sum
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
                ON users.id = projects.posted_by"
    projects = ActiveRecord::Base.connection.execute(index_sql)
    @projects = [[], [], [], [], [], [], []]

    projects.each_with_index do |project, index|
      @projects[index/4] << project
    end
  end

  def new

  end

  def create
    tags = params[:tags].split(",").map(&:capitalize).join(",")
    posted_by = current_user["id"].to_i
    end_date = (Time.now + (60 * 60 * 24 * params[:days].to_i)).to_s
    if params[:title] && params[:goal]
      ActiveRecord::Base.connection.execute("INSERT INTO projects(title, description, posted_by, type, status, maximum_fund, start_date, end_date, created_at, updated_at, tags, search_thumbnail_small, search_thumbnail_large, video_url, location) VALUES('#{params[:title]}', '#{params[:description]}', #{posted_by}, '#{params[:type]}', 'INITIAL', #{params[:goal].to_f}, '#{Time.now.to_s}', '#{end_date}', '#{Time.now.to_s}', '#{Time.now.to_s}', '{#{tags}}', '#{params[:image_url]}', '#{params[:image_url]}', '#{params[:video_url]}', '#{params[:location]}')")

      redirect_to '/projects'
    end
  end

  def show
    @project = ActiveRecord::Base.connection.execute("SELECT * FROM projects WHERE id=#{params[:id].to_i}").first
    @days_left = ActiveRecord::Base.connection.execute("SELECT EXTRACT(EPOCH FROM (end_date - CURRENT_TIMESTAMP))/(60*60*24) AS days_left FROM projects WHERE id=#{params[:id].to_i}").first['days_left']
    @poster = ActiveRecord::Base.connection.execute("SELECT * FROM users WHERE id=#{@project["posted_by"].to_i}").first
    @comments = ActiveRecord::Base.connection.execute("SELECT reviews.comment, users.first_name, users.last_name, reviews.created_at FROM reviews INNER JOIN users ON reviews.user_id = users.id WHERE reviews.type='comment' AND reviews.project_id=#{params[:id].to_i}")
    @ratings = ActiveRecord::Base.connection.execute("SELECT * FROM reviews WHERE type='rating' AND project_id=#{params[:id]}")
    @like = ((ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM reviews WHERE type='like' AND project_id=#{params[:id]} AND user_id=#{current_user['id']}") || []).first || {})['count'].to_i
    @current_user_rating = ((@ratings.select { |x| x['user_id'] == current_user['id']} || []).first || {})['rating'].to_i
    pledges = ActiveRecord::Base.connection.execute("SELECT * FROM pledges WHERE project_id=#{params[:id].to_i}")
    @backers = pledges.map{ |x| x['id']}.uniq.count
    @pledged = 0
    pledges.each do |pledge|
      @pledged += pledge['amount'].to_f
    end

    # binding.pry
  end

  def pledge
    pledge_amount = (params[:pledge]).to_i
    cc_card_id = (ActiveRecord::Base.connection.execute("SELECT id FROM credit_cards WHERE user_id=#{current_user['id'].to_i} AND is_default=true AND is_enabled=true").first || {})['id']
    if pledge_amount > 0 && cc_card_id
      ActiveRecord::Base.connection.execute("INSERT INTO pledges(user_id, project_id, amount, cc_card_id, created_at, updated_at) VALUES(#{current_user['id'].to_i}, #{params[:id].to_i}, #{params[:pledge].to_f}, #{cc_card_id.to_i}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    end
    redirect_to :back
  end

  def rating
    rating = 5 - params[:rating].to_i
    ratings = ActiveRecord::Base.connection.execute("SELECT * FROM reviews WHERE user_id=#{current_user['id'].to_i} AND project_id=#{params[:id].to_i} AND type='rating'")
    if ratings.count > 0
      ActiveRecord::Base.connection.execute("UPDATE reviews SET rating=#{rating}, updated_at=CURRENT_TIMESTAMP WHERE user_id=#{current_user['id'].to_i} AND project_id=#{params[:id].to_i} AND type='rating'")
    else
      ActiveRecord::Base.connection.execute("INSERT INTO reviews(user_id, project_id, type, rating, created_at, updated_at) VALUES(#{current_user['id'].to_i}, #{params[:id].to_i}, 'rating', #{rating}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    end

    redirect_to :back
  end

  def like
    if params[:likeType] == "UNLIKE"
      ActiveRecord::Base.connection.execute("DELETE FROM reviews WHERE type='like' AND user_id=#{current_user['id'].to_i} AND project_id=#{params[:id].to_i}")
    else
      ActiveRecord::Base.connection.execute("INSERT INTO reviews(user_id, project_id, type, created_at, updated_at) VALUES (#{current_user['id'].to_i}, #{params[:id].to_i}, 'like', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    end
    redirect_to :back
  end

  def comment
    if params[:comment].length > 0
      ActiveRecord::Base.connection.execute("INSERT INTO reviews(user_id, project_id, type, comment, created_at, updated_at) VALUES (#{current_user['id'].to_i}, #{params[:id].to_i}, 'comment', '#{params[:comment]}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
    end
    redirect_to :back
  end
end
