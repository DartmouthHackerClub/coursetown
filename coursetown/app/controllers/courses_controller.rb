class CoursesController < ApplicationController

  def index
    @courses = Course.all
    if @current_user.present?
      @wishlist = Wishlist.where(:user_id => @current_user.id)
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
