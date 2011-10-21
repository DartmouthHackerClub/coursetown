class User < ActiveRecord::Base
  has_many :courses, :through => :wishlist
  has_many :offerings, :through => :schedule
end
