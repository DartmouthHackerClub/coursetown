Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :cas, {
    :ssl => true,
    :host => 'login.dartmouth.edu/cas', 
  }
end
