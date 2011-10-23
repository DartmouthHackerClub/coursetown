class ApplicationController < ActionController::Base
  # GET /
  def index
    render :template => "application/index"
  end
end
