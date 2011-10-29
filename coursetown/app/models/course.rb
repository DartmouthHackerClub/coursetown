class Course < ActiveRecord::Base
  has_many :offerings, :through => :offering_courses
  has_many :wishlists
end
