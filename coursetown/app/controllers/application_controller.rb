class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :logged_in_user

  def logged_in_user
    @current_user = User.find(session[:user_id]) if session[:user_id].present?
  end

  # doesn't do anything smart to figure out the term
  def current_year_and_term
    now = Time.now
    terms = %w{W S X F}
    return now.year, terms[(now.month - 1) / 3]
  end

  # TODO
  def not_found
    raise ActiveRecord::RoutingError.new(:not_found)
  end

  # TODO
  def force_login
    # redirect to a login page
    render :file => "public/401.html", :status => :unauthorized
  end

end
