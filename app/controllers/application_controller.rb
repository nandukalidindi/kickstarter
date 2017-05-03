class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def home
    full_index_sql = "SELECT projects.id, projects.title, projects.description, projects.maximum_fund, projects.search_thumbnail_small, projects.search_thumbnail_large, projects.video_url, users.first_name, users.last_name, projects.location, EXTRACT(EPOCH FROM (projects.end_date - CURRENT_TIMESTAMP))/(60*60*24) AS days_left , CASE WHEN pledge_sums.pledge_sum is null THEN 0 ELSE pledge_sums.pledge_sum END
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

    @types = ActiveRecord::Base.connection.execute("SELECT DISTINCT(type) FROM projects")
    @type_projects = ActiveRecord::Base.connection.execute("SELECT * FROM projects WHERE id IN ( SELECT MAX(id) FROM projects GROUP BY type )")

    recommend_sql = full_index_sql + " WHERE projects.id IN (SELECT project_id FROM (SELECT project_id, COUNT(*) as no_of_views FROM events WHERE user_id=#{current_user['id']} AND type='project_views' GROUP BY project_id ORDER BY no_of_views DESC) AS A) ORDER BY random() limit 3";

    @recommendations = ActiveRecord::Base.connection.execute(recommend_sql)

    whatspopular_sql = full_index_sql + " ORDER BY pledge_sum DESC limit 3"

    @whatspopular = ActiveRecord::Base.connection.execute(whatspopular_sql)
  end

  def current_user
    @current_user ||= ActiveRecord::Base.connection.execute("SELECT * FROM users WHERE email='#{session[:user]}'").first
  end
end
