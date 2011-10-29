class OfferingProfessor < ActiveRecord::Base
  belongs_to :offering
  belongs_to :professor
end
