class Schedule < ActiveRecord::Base
  validates :offering, :presence => true
  validates :user, :presence => true
  validate :review_matches_offering
  validate :course_matches_offering
  # course presence is optional (if no course, just grab the default offering.course)

  belongs_to :user
  belongs_to :offering
  belongs_to :course
  belongs_to :review

  def canonical_course
    course || offering.courses.first
  end

  def review_matches_offering
    if review && offering_id != review.offering_id
      errors.add(:offering_mismatch, '. Schedule and Review offerings differ.')
    end
  end

  def course_matches_offering
    if course && !offering.courses.contains?(course)
      errors.add(:offering_mismatch, '. Course does not match offering.')
    end
  end
end
