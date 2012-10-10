class WishlistsController < ApplicationController
  # GET /index
  def index
    if @current_user.present?
      @courses = Course.all
      @wishlist = Wishlist.where(:user_id => @current_user.id)
    end
  end
  
  def create
    if @current_user.present?
      course_id = params["course_id"]
      Wishlist.find_by_course_id_and_user_id(course_id, @current_user.id) || Wishlist.create(:user_id => @current_user.id, :course_id => course_id)
    end
    render :nothing => true
  end
  
  def destroy
    if @current_user.present?
      course_id = params["id"]
      Wishlist.find_by_course_id_and_user_id(course_id, @current_user.id).try(:destroy)
    end
    render :nothing => true
  end    
  
end
