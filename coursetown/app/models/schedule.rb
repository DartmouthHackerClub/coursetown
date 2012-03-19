class Schedule < ActiveRecord::Base
  validates :offering, :presence => true
  validates :user, :presence => true
  # course presence is optional (if no course, just grab the default offering.course)
  # TODO validate that, if course exists, offering.courses.contains? course

  belongs_to :user
  belongs_to :offering
  belongs_to :course
end
