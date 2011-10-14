class Course < ActiveRecord::Base
  has_many :offerings
end
