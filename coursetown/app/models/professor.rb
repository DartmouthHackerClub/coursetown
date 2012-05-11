class Professor < ActiveRecord::Base
  has_many :offering_professors
  has_many :offerings, :through => :offering_professors
  has_many :reviews, :through => :offerings

  validates :name, :presence => true
  validates :last_name, :presence => true

  # NOTE: Professor model should store profs' FULL NAMES. Including initials.
  # sometimes (e.g. when importing CourseGuide) we have a shorter name.

  # if last name isn't set manually, figure it out from the full name
  before_validation do
    return false if self.name.nil?
    if self.last_name.nil? || self.last_name.empty?
      names = self.class.important_names(self.name)
      self.last_name = names[-1] if !names.empty?
    end
    true
  end

  # find_by_fuzzy_name('John Doe') --> <prof name => 'John A. Doe III'>
  # assumes arg is subset of solution. 'John A. Doe III' won't find 'John Doe'
  # if prof_list is provided, searches within that list.
  # else searches by last name
  def self.find_by_fuzzy_name(fuzzy_name, prof_list = nil)
    names = fuzzy_name.split(' ')
    inames = important_names(fuzzy_name)
    last_name = inames[-1]
    matches = prof_list || self.find_all_by_last_name(last_name)
    return nil if matches.empty?

    # try to match the name perfectly
    perfect_matches = matches.select{|x| x.name == fuzzy_name}
    puts "WARNING: multiple professors match name #{fuzzy_name}" if perfect_matches.size > 1
    return perfect_matches.first if perfect_matches.size >= 1

    # else check for something that includes the first name
    perfect_matches = matches.select do |match|
      # if name sizes match, we already know they're not equal, so NO
      next false if match.name.size == fuzzy_name.size
      # else figure out which is smaller and assume the smaller one, if a match
      # is a subset of the larger one
      if match.name.size > fuzzy_name.size
        long_nameset, short_nameset = match.name.split(' '), names
      else
        long_nameset, short_nameset = names, match.name.split(' ')
      end

      i = -1
      # check that the full name includes all the other names AND
      # that the names appear in the correct order
      short_nameset.all? do |nom|
        j = long_nameset.find_index nom
        i && j && j > i && (i = j) # awkward to avoid explicit returns...
      end
    end

    puts "WARNING: multipe professors are fuzzy matches for name #{fuzzy_name}" if perfect_matches.size > 1
    return perfect_matches.first # might return nil
  end

  # returns nil if failed to save
  def self.find_or_create_by_fuzzy_name(fuzzy_name)
    result = self.find_by_fuzzy_name(fuzzy_name)
    return result if result
    result = self.new({:name => fuzzy_name})
    return result.save ? result : nil
  end

  # John A. Doe III => [John,Doe]
  def self.important_names(full_name)
    names = full_name.split(' ')
    important_names = names.select do |str|
      !((str.size == 2 && str[-1] == '.') || # initials
        (str.size > 1 && str.upcase == str) || # roman numerals (all upcase)
        (str == 'Jr.' || str == 'Sr.'))
    end
  end

  # John A. Doe III => John Doe
  def self.short_name(full_name)
    important_names(full_name).join(' ')
  end
end
