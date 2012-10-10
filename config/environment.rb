# Load the rails application
require File.expand_path('../application', __FILE__)

RAILS_GEM_VERSION = '3.1.1' unless defined? RAILS_GEM_VERSION

# Initialize the rails application
Coursetown::Application.initialize!
