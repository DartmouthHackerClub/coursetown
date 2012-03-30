class Review < ActiveRecord::Base
  validates :offering, :presence => true
  validates :user, :presence => true
  validates :grade, :inclusion => 0..12
  validates :prof_rating, :inclusion => 1..5
  validates :course_rating, :inclusion => 1..5

  belongs_to :user
  belongs_to :offering
  has_many :courses, :through => :offering
  has_many :professors, :through => :offering
end
