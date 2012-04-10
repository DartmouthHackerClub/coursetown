class Offering < ActiveRecord::Base
  has_many :offering_courses
  has_many :offering_professors
  has_many :courses, :through => :offering_courses
  # warning: other_offerings is a misnomer. it will include this offering too!
  has_many :other_offerings, :through => :courses, :source => :offerings, :uniq => true
  has_many :professors, :through => :offering_professors
  has_many :distribs
  has_many :schedules
  has_many :reviews

  # TODO: validations!

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

  # sorts an Enumerable<Offering> by time!
  def self.sort_by_time(offerings)
    terms = Hash[%w{W S X F}.each_with_index.to_a]
    times = Hash[%w{8 9L 9S 10 11 12 2 3A 10A 2A 3B}.each_with_index.to_a]
    offerings.sort do |x, y|
      return x.year <=> y.year if y.year && x.year && y.year != x.year
      return terms[x.term] <=> terms[y.term] if x.term && y.term && y.term != x.term
      return times[x.time] <=> times[y.time] if x.time && y.time && y.time != x.time
      return x.section <=> y.section if x.section && y.section
      return 0
    end
  end
end
