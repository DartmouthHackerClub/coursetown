class Schedule < ActiveRecord::Base
  validates :offering, :presence => true
  validates :user, :presence => true
  validates :course, :presence => true
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

  before_validation do
    return true if self.course

    o = self.offering
    return false if o.nil?

    self.course = o.courses.first
    return true
  end

  def canonical_course
    course || offering.courses.first
  end

  def review_matches_offering
    if self.offering_id != review.offering_id
      puts "Schedule[#{self.id}]: OFFERING MISMATCH: Schedule and review offerings differ."
      puts "  -- #{self.offering_id} vs. #{review.offering_id}"
      errors.add(:offering_mismatch, '. Schedule and Review offerings differ.')
    end
  end

  def course_matches_offering
    if (c = self.course) && (o = self.offering) && !o.courses.include?(c)
      puts "COURSE/OFFERING MISMATCH: Course #{self.course.id} AND Offering #{self.offering.id}"
      errors.add(:offering_mismatch, '. Course does not match offering.')
    end
  end
end
