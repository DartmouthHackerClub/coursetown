class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]  
    user = User.find_by_netid(auth["extra"]["netid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end
  
  def destroy
    reset_session
    app = 'CourseTown'
    url = 'http://localhost:4000' # THIS IS BAD!
    redirect_to "https://login.dartmouth.edu/logout.php?app=#{app}&url=#{url}"
  end
  
end
