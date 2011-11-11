class Schedule < ActiveRecord::Base
  belongs_to :user
  belongs_to :offering
  belongs_to :course
end
