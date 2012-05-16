module ApplicationHelper
  def login_path(callback_uri = nil)
    callback_uri ? "/auth/cas?callback_uri=#{callback_uri}" : '/auth/cas'
  end

  def prof_links(offering, short = false)
    s = raw offering.professors.map {|p|
        link_to (short ? p.last_name : p.name), prof_reviews_path(p.id),
        :class => 'prof_link',
        :title => "read reviews for #{p.name}"
      }.join(', ')
    s.blank? ? not_found('none listed') : s
  end

  def course_link(course, offering = nil, short = false)

    prefix = course.compact_title

    if course.long_title.present?
      str = course.long_title
    elsif offering.present? && offering.specific_title.present?
      str = offering.specific_title
    elsif course.short_title.present?
      str = course.short_title
    else
      str = '(title unavailable)'
    end

    full_title = "#{prefix}: #{str}"
    display_title = short ? prefix : full_title
    mouseover_title = short ? full_title : prefix

    link_to display_title, course_reviews_path(:id => course.id),
      :title => "read reviews for #{mouseover_title}"
  end

  def not_found(str, opts={})
    if opts[:class].present?
      opts[:class] += ' not-found'
    else
      opts[:class] = 'not-found'
    end
    content_tag :span, str, opts
  end
end
