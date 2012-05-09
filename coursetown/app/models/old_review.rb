class OldReview < ActiveRecord::Base
  belongs_to :offering, :foreign_key => :old_id, :primary_key => :old_id
end