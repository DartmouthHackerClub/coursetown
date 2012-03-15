class Review < ActiveRecord::Base
  validates :offering, :presence => true
  validates :author, :presence => true
  validates :grade, :inclusion => 0..12
  validates :professor_rating, :inclusion => 1..5
  validates :course_rating, :inclusion => 1..5

  belongs_to :author, :class_name => "User"
  belongs_to :offering
  has_many :courses, :through => :offering
  has_many :professors, :through => :offering
end
