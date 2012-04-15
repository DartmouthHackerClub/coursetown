class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_netid(auth["extra"]["netid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id

    # try to send them back to the page they came from, else send to splash page
    # TODO this method is a callback from "auth/cas", so :back won't work like
    #   we want it to... need to embed back_url in auth/cas url
    begin
      redirect_to :back, :notice => "Signed in!"
    rescue ActionController::RedirectBackError
      puts "Redirect error. Sending user back to splash page."
      redirect_to root_url, :notice => "Signed in!"
    end
  end

  def destroy
    reset_session
    app = 'CourseTown'
    url = 'http://localhost:3000' # THIS IS BAD!
    redirect_to "https://login.dartmouth.edu/logout.php?app=#{app}&url=#{url}"
  end

end
