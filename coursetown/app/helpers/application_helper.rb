module ApplicationHelper
  def login_path(callback_uri = nil)
    callback_uri ? "/auth/cas?callback_uri=#{callback_uri}" : '/auth/cas'
  end

  def prof_links(offering, short = false)
    s = raw offering.professors.map {|p|
      link_to (short ? p.last_name : p.name), prof_reviews_path(p.id), :class => 'prof_link'
      }.join(', ')
    s.blank? ? content_tag(:span, 'none listed', :class => 'not_found') : s
  end
end
