class Offering < ActiveRecord::Base
  has_many :offering_courses
  has_many :offering_professors
  has_many :courses, :through => :offering_courses
  has_many :professors, :through => :offering_professors
  has_many :distribs
  has_many :schedules

end
