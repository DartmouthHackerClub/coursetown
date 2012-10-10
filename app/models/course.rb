class Course < ActiveRecord::Base
  validates :number, :uniqueness => {:scope => :department,
    :message => "Course number can only occur once per dept."}

  # TODO should we add ":include => [:professors, :distribs]" to "has_many offerings"?
  has_many :offering_courses
  has_many :offerings, :through => :offering_courses
  has_many :wishlists
  has_many :schedules # schedules are basically (course, offering) pairs
  has_many :reviews, :through => :offerings
  has_many :old_reviews, :through => :offerings

  def compact_title
  	"#{department} #{number}"
  end
end
