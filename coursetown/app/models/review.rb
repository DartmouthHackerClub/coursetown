class Review < ActiveRecord::Base
  validates_presence_of :offering
  validates_presence_of :user
  validates :grade, :inclusion => 0..12
  validates :prof_rating, :inclusion => 1..5
  validates :course_rating, :inclusion => 1..5

  belongs_to :user
  belongs_to :offering
  has_many :courses, :through => :offering
  has_many :professors, :through => :offering

  # grades_table = { E => 0, ..., A => 12 }
  # TODO is it impossible to get a 1?
  # TODO what's a W?
  @grade_to_letter = %w{E na na D na C- C C+ B- B B+ A- A}
  @letter_to_grade = Hash[@grade_to_letter.each_with_index.to_a]
  # account for 'na's
  [1,2,4].each do |i| @grade_to_letter[i] = nil end
  @letter_to_grade.delete('na')
  # letter-grade/number pairs: for use in <select> menus
  @grade_number_pairs = @grade_to_letter.each_with_index. \
    select{|letter, index| letter}.to_a.reverse

  # convert from number_grade in 0..12 to letter grade
  def letter_grade # getter
    @grade_to_letter[grade]
  end
  def letter_grade= (value) # setter
    g = @letter_to_grade[value]
    grade = g if g
  end

  def self.letter_grade (num_grade)
    @grade_to_letter[num_grade]
  end

  # TODO
  def self.grade_number_pairs
    return @grade_number_pairs
  end
end
