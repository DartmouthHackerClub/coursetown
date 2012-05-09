module ApplicationHelper
  def login_path(callback_uri = nil)
    callback_uri ? "/auth/cas?callback_uri=#{callback_uri}" : '/auth/cas'
  end
end
