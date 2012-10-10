class OfferingCourse < ActiveRecord::Base
  belongs_to :offering
  belongs_to :course
end
