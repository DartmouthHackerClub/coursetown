class SplashController < ApplicationController

  def index
    @review_count = @current_user.reviews.count if @current_user.present?
  end

end