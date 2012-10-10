class Distrib < ActiveRecord::Base
  belongs_to :offering
  @full_names = {
    'INT' => 'International or Comparative Study',
    'ART' => 'Arts',
    'LIT' => 'Literature',
    'SCI' => 'Natural Science',
    'SLA' => 'Natural Science (Lab)',
    'QDS' => 'Quantitative & Deductive Science',
    'SOC' => 'Social Analysis',
    'TAS' => 'Technology or Applied Science',
    'TLA' => 'Technology or Applied Science (Lab)',
    'TMV' => 'Traditions of Thought, Meaning & Value'
  }
  @abbr_list = %w(ART LIT INT SOC TMV QDS SCI SLA TAS TLA)
  @abbr_set = Set.new(@full_names.each_key.to_a)
  validates :distrib_abbr, :inclusion => {:in => @abbr_set,
    :message => "Invalid distrib abbreviation: '%{value}'"}

  def self.full_name(distrib_abbr)
    @full_names[distrib_abbr]
  end

  def full_name
    self.class.full_name(self.distrib_abbr)
  end

  def self.all_abbrs
    @abbr_list.each
  end

  def self.is_abbr?(str)
    @abbr_set.include? str
  end

end
