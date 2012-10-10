#kinda like a wishlist entry or one star in a list of favority items (tag)
class Wishlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
end
