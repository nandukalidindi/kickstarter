class ProjectController < ApplicationController  

  def index
    # binding.pry
    projects = ActiveRecord::Base.connection.execute('SELECT * FROM projects')
    @projects = [[], [], [], [], [], [], []]

    projects.each_with_index do |project, index|
      @projects[index/4] << project
    end

    # binding.pry
  end

  def new
  end

  def show
  end
end
