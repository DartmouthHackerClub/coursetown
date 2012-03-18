class Offering < ActiveRecord::Base
  has_many :offering_courses
  has_many :offering_professors
  has_many :courses, :through => :offering_courses
  has_many :professors, :through => :offering_professors
  has_many :distribs
  has_many :schedules
  has_many :reviews

  # TODO: median, nro, description
  # TODO: full-text search (LIKE clauses)
  def self.search_by_query(queries)
    where_clause = queries.slice(:period, :term, :year, :wc, :time)
    # courses long_title is given as title. Should be a LIKE
    # descr as well ?

    where_clause[:courses] = queries.slice(:department, :number, :long_title,:description)
    (where_clause[:professors] = {:name => queries[:professors]}) if queries.has_key?(:professors)
    (where_clause[:distribs] = {:distrib_abbr => queries[:distribs]}) if queries.has_key?(:distribs)

    # TODO build 'conditions' hash for advanced queries (median > ?, description LIKE ?)

    # TODO first do a 'where' on just offering fields, for a smaller join?
    return Offering.includes(:courses,:professors).where(where_clause)
  end
end
