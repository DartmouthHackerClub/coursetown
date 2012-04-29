class User < ActiveRecord::Base
  has_many :wishlists
  has_many :wishlist_courses, :through => :wishlists, :source => :course
  has_many :wishlist_offerings, :through => :wishlist_courses, :source => :offerings

  has_many :schedules
  # has_many :schedules_with_data, :source => :schedule,
  #   :include => [:review, :offering, :course]
  has_many :schedule_offerings, :through => :schedules, :source => :offering

  has_many :reviews, :through => :schedules

  def self.create_with_omniauth(auth)
    create! do |user|
      user.name = auth["extra"]["name"]
      user.netid = auth["extra"]["netid"]
    end
  end

end
