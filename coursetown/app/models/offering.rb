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
  has_many :old_reviews, :primary_key => :old_id, :foreign_key => :old_id

  validates :term, :inclusion => {:in => %w{F W S X}}, :presence => true
  validates :wc, :inclusion => {:in => [nil,'W','NW','CI']}
  validates :old_id, :uniqueness => true, :unless => 'old_id.nil?'
  # validates all classes w/ old_id are same year & term
  # validates :time, :inclusion => {:in => [nil] + %w{9L 9S 10 11 12 2 3A 3B 10A 2A}}

  # ATTRIBUTES (from schema).
  # sources: timetable, orc, transcript, courseguide, medians
  # everything from transcript's uncertain
  # scheduling data from orc is uncertain
  # fields with holes for transcript (crn, section) should be optional search params
  # t.integer  "year"           tt orc tr cg
  # t.string   "term"           tt orc tr cg
  # t.string   "time"           tt orc
  # t.float    "median_grade"          tr'cg'md
  # t.string   "specific_title" tt     tr'cg
  # t.string   "wc"             ?
  # t.text     "specific_desc"            cg
  # t.boolean  "unconfirmed"    ?
  # t.string   "crn"            tt
  # t.integer  "section"        tt        X  # don't listen to cg's section
  # t.boolean  "nroable"        ?
  # t.string   "building"       ?
  # t.string   "room"           ?
  # t.integer  "enrollment_cap" ?
  # t.integer  "enrolled"       tt'    tr cg'

  # TODO: validations!

  # TODO: median, nro, description
  def self.search_by_query(queries)
    @offerings = Offering.includes(:courses, :professors, :distribs)

    where_clause = queries.slice(:period, :term, :year, :wc, :time)
    where_clause[:courses] = queries.slice(:department, :number, :description)
    if queries and queries.has_key?(:distribs)
      where_clause[:distribs] = {:distrib_abbr => queries[:distribs]}
    end
    if queries and queries.has_key?(:title)
      @offerings = @offerings.where("`courses`.`long_title` like '%#{queries[:title]}%'")
    end
    if queries and queries.has_key?(:professors)
      # asfd, nsadf => "name like '%asfd%' OR name like '%nsadf%'"
      @offerings = @offerings.where(queries[:professors].split(",").map { |name| "`professors`.`name` like '%#{name.strip}%'" }.join(" OR "))
    end
    return @offerings.where(where_clause)
  end

  # TODO use only last names
  def prof_string
    professors.map{|prof| prof.name}.sort.join(', ')
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

  def median_letter_grade
    Review::letter_grade(self.median_grade)
  end
  def median_letter_grade=(val)
    self.median_grade = Review::number_grade(val)
  end
end
