class SchedulesController < ApplicationController
  def index
    @user_id = params[:uid]
    @offerings = Schedule.find_all_by_user_id(@user_id).map(&:offering)
    @user = User.find(@user_id)
  end
end
