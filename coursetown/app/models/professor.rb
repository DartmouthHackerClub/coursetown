class Professor < ActiveRecord::Base
    has_many :offering_professors
    has_many :offerings, :through => :offering_professors
    has_many :reviews, :through => :offerings
end
