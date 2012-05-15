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
      user.hashed_netid = self.hash_netid(auth["extra"]["netid"])
    end
  end

  def self.hash_netid(netid)
    Digest::SHA1.hexdigest(netid)
  end
  def self.find_by_netid(netid)
    self.find_by_netid_sha1(self.netid_to_sha1(netid))
  end
end
