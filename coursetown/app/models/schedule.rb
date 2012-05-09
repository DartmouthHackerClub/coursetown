class Schedule < ActiveRecord::Base
  validates :offering, :presence => true
  validates :user, :presence => true
  validate :course_matches_offering
  validates :offering_id, :uniqueness => {:scope => :user_id,
    :message => 'User cannot write multiple reviews for one course offering'}
  # course presence is optional (if no course, grab the default offering.course)
  with_options :unless => 'review.nil?' do |sched|
    sched.validates :review_id, :uniqueness => true
    sched.validate :review_matches_offering
  end

  belongs_to :user
  belongs_to :offering
  belongs_to :course
  belongs_to :review

  def canonical_course
    course || offering.courses.first
  end

  def review_matches_offering
    if offering_id != review.offering_id
      errors.add(:offering_mismatch, '. Schedule and Review offerings differ.')
    end
  end

  def course_matches_offering
    if course && offering && !offering.courses.include?(course)
      errors.add(:offering_mismatch, '. Course does not match offering.')
    end
  end
end
