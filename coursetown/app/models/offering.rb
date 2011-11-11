class Offering < ActiveRecord::Base
  has_many :offering_courses
  has_many :offering_professors
  has_many :courses, :through => :offering_courses
  has_many :professors, :through => :offering_professors
  has_many :distribs
  has_many :schedules
  def self.search_by_query(queries)
    where_clause = queries.slice(:periods,:term,:year, :wc,:time)
    # courses long_title is given as title. Should be a LIKE
    # descr as well ? 
    # 
    where_clause[:courses] = queries.slice(:department, :number, :long_title,:description)
    # where_clause[:professors] = queries.slice(:professors) - Add full text search / like ?
    return Offering.joins(:courses,:professors).where(where_clause).includes(:courses, :professors)
  end
end
