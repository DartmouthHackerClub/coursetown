class Offering < ActiveRecord::Base
  has_many :courses, :through => :offering_courses
  has_many :professors, :through => :offering_professor

  has_many :schedules
end
