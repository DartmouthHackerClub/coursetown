class SchedulesController < ApplicationController
  def index
    if @current_user.present?
      @offerings = Schedule.where(:user_id => @current_user.id).includes(:offering => [:courses, :distribs]).map(&:offering)
    end
  end
end