class ProjectController < ApplicationController

  def index
    projects = ActiveRecord::Base.connection.execute('SELECT * FROM projects')
    @projects = [[], [], [], [], [], [], []]

    projects.each_with_index do |project, index|
      @projects[index/4] << project
    end
  end

  def new
    # binding.pry
  end

  def create
    # binding.pry
  end

  def show
  end
end
