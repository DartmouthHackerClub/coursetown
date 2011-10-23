class ApplicationController < ActionController::Base
  # GET /
  def index
    render :template => "layouts/index.html.erb"
  end
end
