class User < ActiveRecord::Base
  has_many :wishlists
end
