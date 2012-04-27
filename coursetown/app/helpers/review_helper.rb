module ReviewHelper
  def star_count (stars, max_stars = 5)
    "#{stars} stars"
  end

  # to be called from within the scope of form_for
  def star_rating (form, field_name, max_stars = 5)
    form.select field_name, (1..max_stars).map{|x| [x,x]}.to_a
  end

  # TODO make a nothing-selected option
  def star_rating_tag (name, max_stars=5)
    select_tag name, options_for_select((1..max_stars).map{|x| [x,x]}.to_a, 3)
  end

  # TODO format grade according to above/below/at median
  def letter_grade (raw_grade, median = 8)
    Review.letter_grade(raw_grade+1) || '?'
  end

  def reasons_tag(name, selected_field = :for_interest)
    reasons = [
      ['Interest',:for_interest],
      ['Major/Minor',:for_major],
      ['Distrib/WC', :for_distrib],
      ['Prof',:for_prof],
      ['Easy A',:for_easy_a],
      ['Prereqs',:for_prereqs]
    ]
    select_tag name, options_for_select(reasons, selected_field)
  end

end
