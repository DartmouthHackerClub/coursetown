class Review < ActiveRecord::Base
  validates_presence_of :offering
  validates :grade, :inclusion => 0..24 # grades are weird
  validates :prof_rating, :inclusion => 1..5
  validates :course_rating, :inclusion => 1..5
  validate :matches_schedule_offerings
  validate :has_reasons

  belongs_to :offering
  belongs_to :schedule
  has_one :user, :through => :schedule
  has_many :courses, :through => :offering
  has_many :professors, :through => :offering

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
    select{|letter, index| letter && index.even?}.to_a << ['',-1]).reverse

  # convert from number_grade in 0..24 to letter grade
  def letter_grade # getter
    self.class.letter_grade(grade)
  end
  def letter_grade= (value) # setter
    g = self.class.number_grade(value)
    grade = g if g
  end
  def self.letter_grade (num_grade)
    @grade_to_letter[num_grade]
  end
  def self.number_grade (letter_grade)
    val = letter_grade.chomp('*') # ignore citation stars
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
    if schedule && offering_id != schedule.offering_id
      errors.add(:offering_mismatch, '. Review offering must match schedule offering')
    end
  end

  # each review must mark at least one motivation for taking the course
  def has_reasons
    if !(for_major || for_prof || for_interest ||
        for_distrib || for_easy_a || for_prereq)
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
    sum, count = {}, {}
    dimensions.each { |dim| sum[dim] = count[dim] = 0 }
    records.each do |record|
      dimensions.each do |dim|
        if record[dim]
          sum[dim] += record[dim].to_f
          count[dim] += 1
        end
      end
    end
    # turn sum into avg
    sum.each_key { |key| count[key] != 0 ? sum[key] /= count[key].to_f : nil }
    return sum, count
  end

end
