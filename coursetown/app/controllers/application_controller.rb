include ApplicationHelper

class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :logged_in_user

  def logged_in_user
    @current_user = User.find_by_id(session[:user_id])
  end

  # TODO
  def not_found
    raise ActiveRecord::RoutingError.new(:not_found)
  end

  def force_login (callback_uri = nil)
    # redirect to a login page
    # NOTE: hacky way of building a uri, but it's because /auth/cas
    #   doesn't exist in a Rails-y way.
    redirect_to login_path(callback_uri), :alert => 'You need to log in to do that.'
  end

end
