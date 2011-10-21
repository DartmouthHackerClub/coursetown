class WishlistsController < ApplicationController
  # GET /index
  def index
    @user_id = params[:uid]
    @courses = Wishlist.find_all_by_user_id(@user_id).map(&:course)
    @user = User.find(@user_id)
  end
end
