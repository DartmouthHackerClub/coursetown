class Course < ActiveRecord::Base
  # TODO should we add ":include => [:professors, :distribs]" to "has_many offerings"?
  has_many :offering_courses
  has_many :offerings, :through => :offering_courses
  has_many :wishlists
  has_many :schedules # schedules are basically (course, offering) pairs
  has_many :reviews

  def compact_title
  	"#{department} #{number}"
  end
end
