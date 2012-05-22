class Review < ActiveRecord::Base
  validates_presence_of :offering
  validates :grade, :inclusion => 0..24, :if => 'grade.present?' # grades are weird
  validates :prof_rating, :inclusion => 1..5
  validates :course_rating, :inclusion => 1..5
  validate :matches_schedule_offerings
  validate :has_reasons

  belongs_to :offering
  has_one :schedule
  has_one :user, :through => :schedule
  has_many :courses, :through => :offering
  has_many :professors, :through => :offering

  attr_accessible :course_rating, :prof_rating, :workload_rating, :grade,
    :course_comment, :prof_comment, :workload_comment, :offering_id,
    :for_major, :for_prof, :for_prereq, :for_easy_a, :for_interest, :for_distrib

  # grades_table = { letter => 6 * GPA }
  # 6* because there are 3 levels for each letter (B-,B,B+), plus APPARENTLY
  # medians can be listed as "B+/B" which is why each letter's multiplied by 2
  @grade_to_letter = %w{E na na na na na D na na na C- C-/C C C/C+ C+ C+/B- B- B-/B B B/B+ B+ B+/A- A- A-/A A}
  @letter_to_grade = Hash[@grade_to_letter.each_with_index.to_a]
  @letter_to_grade['ON'] = nil
  # account for 'na's
  @grade_to_letter.each_with_index do |letter, i|
    @grade_to_letter[i] = nil if letter == 'na'
  end
  @letter_to_grade.delete('na')
  # letter-grade/number pairs: for use in <select> menus
  # ignore "split" values, e.g. B/B+
  @grade_number_pairs = (@grade_to_letter.each_with_index.
    select{|letter, index| letter && index.even?}.to_a << ['','']).reverse

  # convert from number_grade in 0..24 to letter grade
  def letter_grade # getter
    self.class.letter_grade(grade)
  end
  def letter_grade= (value) # setter
    g = self.class.number_grade(value)
    grade = g if g
  end
  def self.letter_grade (num_grade)
    return nil if !num_grade.instance_of?(Fixnum)
    @grade_to_letter[num_grade]
  end
  def self.number_grade (letter_grade)
    val = letter_grade.strip.chomp('*').strip # ignore whitespace and citation stars
    @letter_to_grade[val]
  end

  # grade/number pairs for reporting your own grade in a <select> tag
  def self.grade_number_pairs
    return @grade_number_pairs
  end

  # CUSTOM VALIDATIONS

  # TODO issue: when creating a review, isn't hooked up to schedule UNTIL saved.
  # so this only works if the schedule already exists
  def matches_schedule_offerings
    if self.schedule && self.offering_id != self.schedule.offering_id
      puts "OFFERING MISMATCH: #{self.offering_id} vs. #{self.schedule.offering_id}"
      errors.add(:offering_mismatch, '. Review offering must match schedule offering')
    end
  end

  # STUFF ABOUT REASONS

  @reason_names = {'for_interest' => 'Interest', 'for_prof' => 'Prof',
    'for_easy_a' => 'Easy A', 'for_distrib' => 'Distrib/WC',
    'for_major' => 'Major/Minor', 'for_prereq' => "Prereqs"}

  # list of all reasons this review offers (as human-readable strings)
  def self.list_reasons(review)
    @reason_names.map{|key, value| value if review.attributes[key]}.compact
  end
  # hacky, but I think this is the best way to do it?
  def list_reasons
    self.class.list_reasons(self)
  end
  # each review must mark at least one motivation for taking the course
  def has_reasons
    if !(for_major || for_prof || for_interest || for_distrib || for_easy_a || for_prereq)
      puts "HAS NO REASONS: incomplete review"
      errors.add(:incomplete, '. Review must list at least one motivation')
    end
  end


  @dimensions_for_average = [:grade, :course_rating, :prof_rating, :workload_rating]
  def self.average_reviews(reviews)
    average_records(reviews, @dimensions_for_average)
  end


  # TODO this is a HORRIBLE place to put this function, but I don't know where
  # it _should_ go, so in the interest of time I'm putting it here
  def self.average_records(records, dimensions)
    # TODO this is really not the right place to put this, but
    # it's better than in a controller?

    return {}, {} if records.blank?

    sum, count = {}, {}
    dimensions.each { |dim| sum[dim] = count[dim] = 0 }
    records.each do |record|
      dimensions.each do |dim|
        if record[dim].present? && record[dim] != 0
          sum[dim] += record[dim].to_f
          count[dim] += 1
        end
      end
    end

    # turn sum into avg
    sum.each_key { |key| (count[key] != 0) ? (sum[key] /= count[key].to_f) : nil }
    return sum, count
  end

end
