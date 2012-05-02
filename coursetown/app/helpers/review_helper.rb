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

  # arg: transcript_html = full html page from [undergrad, undergrad]
  # returns: array of {year,term,department,number,enrollment,median,grade} objs
  def parse_transcript(transcript_html)
    doc = Hpricot(transcript_html)
    rows = doc/'table.datadisplaytable tr'

    terms = {'winter' => 'W', 'fall' => 'F', 'summer' => 'X', 'spring' => 'S'}
    scraped_data = []
    current_term, current_year = 0,0
    rows.each do |row|

      children = row/'td'

      if children.empty?
        # term divider?
        if (labels = row/'th.ddlabel') && labels.size == 1 &&
            (label = labels.first) && label.attributes['colspan'].to_i == 12 &&
            (span = label/'span') && (contents = span.inner_html)

          term, mid, year = contents.split(' ')
          if term && mid && year && mid.downcase == 'term' &&
              (year = year.to_i) != 0 && (term = terms[term.downcase])

            current_term, current_year = term, year
          end
        end
      # if the row's all '.dddefault's, it's a course! scrape and record it.
      elsif children.size == 8 &&
          children.all?{|td| !(td.classes & ['dddefault', 'dddead']).empty? }

        h = Hash.new
        h[:year], h[:term] = current_year, current_term
        h[:department], h[:number], _, _, h[:enrollment], h[:median], h[:grade] =
          children.map {|td| td.classes.include?('dddead') ? nil : td.inner_html}
        scraped_data << h
      end
    end

    puts "Just scraped #{scraped_data.size} courses off a transcript"
    scraped_data
  end

end
