module ReviewHelper
  def star_count (stars, max_stars = 5)
    "#{stars} stars"
  end

  # to be called from within the scope of form_for
  def star_rating (form, field_name, max_stars = 5)
    form.select field_name, (1..max_stars).to_a.each_with_index.to_a
  end

  # TODO format grade according to above/below/at median
  def letter_grade (raw_grade, median = 8)
    Review.letter_grade(raw_grade)
  end

end
