class Offering < ActiveRecord::Base
  has_many :offering_courses
  has_many :offering_professors
  has_many :courses, :through => :offering_courses
  # warning: other_offerings is a misnomer. it will include this offering too!
  has_many :other_offerings, :through => :courses, :source => :offerings, :uniq => true
  has_many :professors, :through => :offering_professors
  has_many :distribs, :dependent => :destroy
  has_many :schedules
  has_many :reviews
  has_many :old_reviews, :primary_key => :old_id, :foreign_key => :old_offering_id

  validates :term, :inclusion => {:in => %w{F W S X}}, :presence => true
  validates :wc, :inclusion => {:in => ['W','NW','CI']}, :if => 'wc.present?'
  validates :old_id, :uniqueness => true, :unless => 'old_id.nil?'
  # validates all classes w/ old_id are same year & term
  # validates :time, :inclusion => {:in => [nil] + %w{9L 9S 10 11 12 2 3A 3B 10A 2A}}

  @terms = Hash[%w{W S X F}.each_with_index.to_a]
  @times = Hash[%w{8 9L 9S 10 11 12 2 3A 10A 2A 3B}.each_with_index.to_a]

  before_validation do |o|
    o.wc = o.wc.strip.upcase if o.wc
    o.term = o.term.strip.upcase if o.term
    o.time = o.time.strip.upcase if o.time
  end

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

  # FIXME: HUGE SQL INJECTION VULNERABILITY. HUGE.

  def self.list_times
    %w{8 9L 9S 10 11 12 2 3A 10A 2A 3B}
  end

  # TODO: median, nro, description
  def self.search_by_query(queries, limit=300)
    return [] if queries.blank? || queries.each_value.all?{|v| v.blank?}

    # for most keys (professor, course, description), it's better do a left
    # join w/ THAT table on the left, not offerings.

    ### build the query

    seeded_from_offerings = true
    q = {}
    if queries[:title].present?
      q[:title] = "courses.long_title like '%#{queries[:title]}%'"
    end
    if queries[:description].present?
      q[:desc] = queries[:description].split(",").
          map { |name| "courses.desc like '%#{name.strip}%'" }.join(" OR ")
    end
    if queries[:prof].present?
      q[:prof] = queries[:prof].split(",").map { |name| "professors.name like '%#{name.strip}%'" }.join(" OR ")
    end
    q[:course] = Hash[queries.slice(:department, :number).map{|k,v| ["courses.#{k.to_s}",v]}]
    q[:offering] = Hash[queries.slice(:period, :term, :year, :wc, :time).map{|k,v| ["offerings.#{k.to_s}",v]}]
    q[:distrib] = {'distribs.distrib_abbr' => queries[:distrib]} if queries[:distrib].present?
    # TODO: right now it returns null-grade courses too when user searches for median grade. good choice? bad choice?
    if (med = queries[:median]).present? && med.to_i.to_s == med.to_s
      q[:median] = "offerings.median_grade >= #{(queries[:median].to_f * 6).round} OR offerings.median_grade IS NULL"
    end

    ### get the query STARTED

    # if there's a prof name, that's a great place to star! any one prof only has a few offerings
    if (my_query = q.delete(:prof)).present?
      seeded_from_offerings = false
      seed = Professor.where(my_query).includes(:offerings => [:professors, :courses, :distribs])

    # if there's a description, a title, or BOTH department AND number, start w/ courses
    elsif q[:description].present? || q[:title].present? || (q[:course].present? && q[:course].size == 2)
      seeded_from_offerings = false
      seed = Course
      [:description, :title, :course].each do |k|
        if (d = q.delete(k)).present?
          seed = seed.where(d)
        end
      end
      seed = seed.includes(:offerings => [:professors, :courses, :distribs])

    else
      seeded_from_offerings = true
      seed = Offering
      if (d = q.delete(:offering)).present?
        seed = seed.where(d)
      end
      seed = seed.includes(:professors, :courses, :distribs)
    end

    # add the remaining queries to this big ol' query
    q.each_value.select(&:present?).each{ |v| seed = seed.where(v) }

    if seeded_from_offerings
      return seed.limit(limit)
    else
      return seed.limit(limit).map(&:offerings).flatten.uniq
    end
  end

  def prof_string
    Professor.prof_string(self.professors)
  end

  def short_prof_string
    professors.map{|prof| prof.last_name}.sort.join(', ')
  end

  def semi_short_prof_string
    professors.map{|prof| "#{prof.name[0]}. #{prof.last_name}"}.sort.join(', ')
  end

  def smart_prof_string
    self.professors.size > 1 ? semi_short_prof_string : prof_string
  end

  def course_string
    titles = self.courses.map(&:compact_title).sort
    if titles.empty?
      ''
    elsif titles.size == 1
      titles.first
    else
      "#{titles.first} aka #{titles[1,titles.size].join(', ')}"
    end
  end

  def time_string
    prefix = "#{self.year}#{self.term}"
    if self.time
      "#{prefix} @ #{self.time}"
    else
      prefix
    end
  end

  def summary_string
    "#{time_string} - #{short_prof_string}"
  end

  def long_summary_string
    return self.summary_string if self.section.blank?
    "#{self.summary_string} (sec. #{self.section})"
  end

  # NOTE: don't call .title unless the course is INCLUDED
  def title
    t = nil
    # default to long title
    long_titles = self.courses.map(&:long_title)
    return t if (t = long_titles.find(&:present?)).present?

    # then try specific title. then short title
    return self.specific_title if self.specific_title.present?

    short_titles = self.courses.map(&:short_title)
    return t if (t = short_titles.find(&:present?)).present?

    return '(Title Unavailable)'
  end

  def self.compare_times(x, y)
    return x.year <=> y.year if y.year && x.year && y.year != x.year
    return @terms[x.term] <=> @terms[y.term] if x.term && y.term && y.term != x.term
    return @times[x.time] <=> @times[y.time] if x.time && y.time && y.time != x.time
    return (x.section || -1) <=> (y.section || -1) # sections come after nil-section
  end

  def is_before?(offering)
    self.class.compare_times(self, offering) < 0
  end

  def is_after?(offering)
    self.class.compare_times(self, offering) > 0
  end

  def self.has_happened?(offering)
    now = Time.now
    yr = now.year
    trm = ((now.month - 1) / 3) % 4
    o = offering

    return o.year < yr if o.year && yr && o.year != yr
    return @terms[o.term] < trm if @terms[o.term]
    false
  end

  def has_happened?
    self.class.has_happened?(self)
  end

  # sorts an Enumerable<Offering> by time!
  def self.sort_by_time(offerings)
    offerings.sort do |x, y|
      compare_times(x,y)
    end
  end

  # useful for sorting
  def self.term_as_number(term_str)
    @terms[term_str]
  end
  def term_as_number
    @terms[self.term]
  end

  def median_letter_grade
    Review::letter_grade(self.median_grade)
  end
  def median_letter_grade=(val)
    self.median_grade = Review::number_grade(val)
  end

  def self.average_reviews(offerings)
    offerings = [*offerings] # take a single or multiple args
    reviews = offerings.map(&:reviews).flatten
    old_reviews = offerings.map(&:old_reviews).flatten

    avgs, count = Review.average_reviews(reviews)
    old_avgs, old_count = OldReview.average_reviews_for_new_schema(old_reviews)

    # merge
    [:course_rating, :workload_rating].each do |key|
      a = avgs[key] || 0
      c = count[key] || 0
      a2 = old_avgs[key] || 0
      c2 = old_count[key] || 0
      count[key] = c + c2
      avgs[key] = c + c2 != 0 ? (a * c + a2 * c2) / (c + c2) : nil
    end

    # calculate the median separately (from offerings, not reviews)
    msum, mcount = 0, 0
    offerings.each do |o|
      if o.median_grade.present? && o.median_grade != 0
        msum += o.median_grade
        mcount += 1
      end
    end
    avgs[:median] = (msum.to_f / mcount.to_f).to_i if mcount > 0

    avgs[:num_reviews] = reviews.size + old_reviews.size
    avgs[:num_offerings] = offerings.size

    # TODO would it make more sense to stuff reviews & old_reviews in the hash too?
    return avgs, reviews, old_reviews
  end

  # assumes offerings includes distribs (otherwise is super inefficient)
  # returns hsh, where hsh[INT] = true if EVERY offering has an INT,
  #   false if only some do, and non-existent if none do
  def self.get_reqs(offerings)
    return {} if offerings.size == 0
    hsh = Hash[ [*%w(W NW CI), *Distrib.all_abbrs].map{|x| [x,0]} ]
    offerings.each do |offering|
      offering.get_reqs.each do |d|
        if hsh[d]
          hsh[d] += 1
        elsif d.present?
          logger.warn "Offering #{offering.id} has invalid WC/DISTRIB: '#{d}'"
        end
      end
    end
    hsh.delete_if{|k,v| v == 0}
    puts "DISTRIBS/WC: #{hsh}"
    hsh.each do |k,v|
      hsh[k] = v == offerings.size
    end
    hsh
  end
  def get_reqs
    [*self.wc, *self.distribs.map(&:distrib_abbr)]
  end
end
