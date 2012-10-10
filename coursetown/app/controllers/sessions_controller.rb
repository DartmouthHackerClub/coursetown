class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]

    # TODO it seems EVERYONE's affiliation is DART. How can I check if someone's a Prof?
    if !%w(DART).include? auth["extra"]["affil"]
      redirect_to (params[:callback_uri] || root_url), :notice => %(We're sorry, \
        but you don't have access to this part of the site. It's reserved for \
        Dartmouth students.)
    end

    user = User.find_by_netid(auth["extra"]["netid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id

    # try to send them back to the page they came from, else send to splash page
    # TODO this method is a callback from "auth/cas", so :back won't work like
    #   we want it to... need to embed back_url in auth/cas url
    redirect_to (params[:callback_uri] || root_url), :notice => "Signed in!"
  end

  def destroy
    reset_session
    app = 'CourseTown'
    url = root_url
    redirect_to "https://login.dartmouth.edu/logout.php?app=#{app}&url=#{url}"
  end

end
