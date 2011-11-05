class WishlistsController < ApplicationController
  # GET /index
  def index
    if @current_user.present?
      @courses = Wishlist.find_all_by_user_id(@current_user.id).map(&:course)
    end
  end
end
