module ReviewHelper

  @workload_labels = ['really light', 'pretty light', 'average', 'heavy', 'intense']

  def star_count (id, stars, default = nil, options = {})
    return default || (raw '<span class="not-found">no ratings</span>') if stars.nil?
    render :partial => 'stars', :locals => options.merge({
      :id => id, :read_only => true, :score => stars
      })
  end

  # to be called from within the scope of form_for
  def star_rating (form, field_name, options = {})
    full_name = "#{form.object_name}[#{field_name}]"
    star_rating_tag(full_name, options)
  end

  # options:
  #   id: span element's html id (has smart default)
  #   class: span element's html class (auto-includes 'star-rating')
  #   hints: (roll-over text), e.g. [bad,meh,ok,good,great]
  #   cancel: true if you want a cancel button
  #   cancel_place: 'left' or 'right'
  def star_rating_tag (name, options = {})
    # select_tag name, options_for_select((1..max_stars).map{|x| [x,x]}.to_a, 3)
    render :partial => 'stars', :locals => options.merge({:field_name => name.to_s})
  end

  # if grade's not valid/DNE, return default instead
  def letter_grade (number_grade, default = '?')
    return default if number_grade.blank? || !number_grade.instance_of?(Fixnum)
    Review.letter_grade(number_grade) || default
  end

  def reasons_tag(name, selected_field = :for_interest)
    reasons = [
      ['',''],
      ['Major/Minor',:for_major],
      ['Distrib/WC/Other Req.', :for_distrib],
      ['Easy A',:for_easy_a],
      ['Prof',:for_prof],
      ['Prereqs',:for_prereq],
      ['Interest',:for_interest],
    ]
    select_tag name, options_for_select(reasons, ''), :class => 'select-reasons'
  end

end
