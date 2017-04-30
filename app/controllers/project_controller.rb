class ProjectController < ApplicationController

  def index
    projects = ActiveRecord::Base.connection.execute('SELECT * FROM projects')
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
  end
end
