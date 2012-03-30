module ReviewHelper
  def star_count (stars, max_stars = 5)
    "#{stars} stars"
  end

  # to be called from within the scope of form_for
  def star_rating (form, field_name, max_stars = 5)
    form.select field_name, (1..max_stars).to_a.each_with_index.to_a
  end

  # TODO format grade according to above/below/at median
  def grade (raw_grade, median = 8)
    # if 'raw_grade' is a number, first turn it into a string
    if raw_grade.kind_of? Fixnum
      return @@grade_to_letter[raw_grade]
    elsif raw_grade.kind_of? String
      return raw_grade
    end
  end

  # grades_table = { E => 0, ..., A => 12 }
  # TODO is it impossible to get a 1?
  @@grade_to_letter = %w{E na na D na C- C C+ B- B B+ A- A}
  @@letter_to_grade = Hash[@@grade_to_letter.each_with_index.to_a]
  # account for 'na's
  [1,2,4].each do |i| @@grade_to_letter[i] = nil end
  @@letter_to_grade.delete('na')
  @@grade_list = @@letter_to_grade.to_a

  # convert from number_grade in 0..12 to letter grade
  def letter_grade # getter
    @@grade_to_letter[grade]
  end
  def letter_grade= (value) # setter
    g = @@letter_to_grade[value]
    grade = g if g
  end
  
  def grade_list
    return @@grade_list
  end

end
