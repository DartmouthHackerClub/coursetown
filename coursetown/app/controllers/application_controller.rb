class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :logged_in_user

  def logged_in_user
    @current_user = User.find_by_id(session[:user_id])
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

  def force_login (callback_uri = nil)
    # redirect to a login page
    # NOTE: hacky way of building a uri, but it's because /auth/cas
    #   doesn't exist in a Rails-y way.
    uri = callback_uri ? "/auth/cas?callback_uri=#{callback_uri}" : '/auth/cas'
    redirect_to uri, :alert => 'You need to log in to do that.'
  end

end
