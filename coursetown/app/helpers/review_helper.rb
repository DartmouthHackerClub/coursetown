module ReviewHelper
  def star_count (stars, max_stars = 5)
    "#{stars} stars"
  end

  # to be called from within the scope of form_for
  def star_rating (form, field_name, max_stars = 5)
    form.select field_name, (1..max_stars).map{|x| [x,x]}.to_a
  end

  def star_rating_tag (name, max_stars=5)
    select name, (1..max_stars).map{|x| [x,x]}.to_a
  end

  # TODO format grade according to above/below/at median
  def letter_grade (raw_grade, median = 8)
    Review.letter_grade(raw_grade+1) || '?'
  end

end
