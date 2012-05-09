class CoursesController < ApplicationController

  def index
    @courses = Course.find(:all,:conditions => ['long_title LIKE ?', "%#{params[:term]}%"],  :limit => 10, :order => 'long_title')
    #@courses = Course.all
    respond_to do |format|
      format.json { render :json => @courses.map(&:long_title).compact.reject(&:blank?).to_json }
    end
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def create
    @course = Course.new(params[:course])
  end

  def update
    @course = Course.find(params[:id])
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    redirect_to(courses_url)
  end
end
