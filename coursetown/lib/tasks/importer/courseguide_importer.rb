class CourseguideImporter

  def initialize new_thing, old_thing
    puts "Importing from #{old_thing} to #{new_thing}"

    @newDb = new_thing
    @oldDb = old_thing
  end

  def execute
    course_mapping = import_courses
    offering_mapping = import_offerings(course_mapping)
    import_professors(offering_mapping)
    import_reviews
    puts "Finished importing from #{@oldDb}"
  end

  def use_source
    ActiveRecord::Base.connection.execute("use #{@oldDb};")
  end

  def use_target
    ActiveRecord::Base.connection.execute("use #{@newDb};")
  end

  # returns
  def import_courses
    puts "Importing courses from CourseGuide..."
    use_source
    courses = ActiveRecord::Base.connection.execute(
      'SELECT courseid, coursenumber, code, deptclass
      FROM whatsubject
      INNER JOIN departments ON whatsubject.dept = departments.id;')
    use_target
    course_rows = courses.each_row.to_a
    puts "CourseGuide has #{course_rows.size} total courses"

    # weirdly, courses.count is only correct the FIRST time it's called
    # so we need to manually count, because each_row calls .count
    added_count = 0

    # add any missing courses to DB
    # & build courses hash: old_offering_id => new_course_ids
    new_courses = Hash.new
    course_rows.each do |row|

      if row['courseid'] == 17053
        puts "FOUND IT! #{%w{courseid code coursenumber}.map{|s| "#{s}:#{row[s]}"}}"
      end

      # try to find something with either "code" or "deptclass" as the 4-letter
      # department code. "deptclass" is often null, so we should rely on "code"
      course = Course.find_by_department_and_number([row['code'], row['deptclass']],row['coursenumber'])
      if course.nil?
        course = Course.new({:department => row['code'], :number => row['coursenumber']})
        course.save!
        added_count += 1
      end

      # new_courses[row['courseid']] << course
      (new_courses[row['courseid']] ||= []) << course
    end
    puts "Added #{added_count} new courses"

    new_courses
  end


  def import_offerings(new_courses)
    puts "Importing offerings from CourseGuide..."

    # NOTE: courseguide has section data, but it's weird and wrong, and they
    #   ignore it. so let's ignore it too. it's only useful for scheduling
    #   anyways, but all courseguide data is in the past!

    use_source
    offerings = ActiveRecord::Base.connection.execute(
      'SELECT id AS courseid, year, term, median, listedas, coursedesc, enrollment
      FROM courses;')
    use_target
    offering_rows = offerings.each_row.to_a

    term_conversion = {'Winter' => 'W', 'Summer' => 'X',
      'Spring' => 'S', 'Fall' => 'F'}

    puts "CourseGuide has #{offering_rows.size} total offerings"
    added_count = 0

    attributes = %w{courseid year term listedas enrollment median}

    # add old offerings
    # and record the new offering_id they're mapped to
    new_offering = Hash.new
    offering_rows.each do |row|

      # first try to find by old_id
      offering = Offering.find_by_old_id(row['courseid'])
      # if an offering's found, check it matches (or warn the dev)
      if offering
        if offering.year != row['year'] ||
          offering.term != term_conversion[row['term']]

          puts "\n\nERROR: offering w/ old_id #{row['courseid']} doesn't match."
          puts "#{offering.attributes} \n -- VS -- \n#{%w{year term section}.map{|x| [x,row[x]]}}"
          raise Exception.new "offering w/ old_id #{row['courseid']} doesn't match"
        end
      else # coudn't find an offering w/ this old_id
        # try to find an existing offering, via courses, that matches this one
        if (courses = new_courses[row['courseid']]).nil?
          # some courses are missing departments. just drop them.
          puts "No courses match offering #{ attributes.map{|a| "#{a}: #{row[a]}"} }"
          next
        end
        course = courses.first
        # find offerings that match the course & section AND don't have an old id
        where_clause = {
          :year => row['year'],
          :term => term_conversion[row['term']],
          :old_id => nil, # if it matched old_id, we'd have found it already
        }
        potential_offerings = course.offerings.where(where_clause)

        if !potential_offerings.empty?
          # grab something that matches the section, else an arbitrary offering
          if potential_offerings.size == 1
            offering = potential_offerings.first
          else
            # TODO find by prof if multiple matches exist
            potential_offerings.select! do |o|
              (row['median'].nil? || o.median_grade.nil? ||
                row['median'] == o.median_grade) &&
              (row['enrollment'].nil? || o.enrolled.nil? ||
                row['enrollment'] == o.enrolled)
            end
            if potential_offerings.size == 1
              offering = potential_offerings.first
            else
              raise Exception.new "Multiple offerings for #{where_filter}"
            end
          end
        end
      end

      # if that didn't work, create an offering
      if offering.nil?
        offering = Offering.new({:year => row['year'], :term => term_conversion[row['term']]})
        added_count += 1
      end

      # set any offering attributes that aren't yet set
      offering.old_id = row['courseid']
      offering.median_grade ||= row['median'] # old reviews uses the same 0-24 system
      offering.enrolled ||= row['enrollment']
      offering.specific_desc ||= row['coursedesc']
      offering.specific_title ||= row['listedas']
      offering.courses = new_courses[offering.old_id]

      offering.save!

      new_offering[offering.old_id] = offering
    end
    puts "Added #{added_count} new offerings."

    new_offering
  end


  def import_professors(new_offerings)
    puts "Importing professors from CourseGuide..."

    use_source
    professors = ActiveRecord::Base.connection.execute(
      'SELECT id, name FROM professors')
    teach_whats = ActiveRecord::Base.connection.execute(
      'SELECT profid, courseid FROM teachwhat')
    use_target

    puts "CourseGuide has #{professors.size} total professors and #{teach_whats.size} prof/offering pairings"
    added_count = 0

    # add profs
    new_profs = Hash.new # prof_id (from courseguide) => Professor object
    professors.each_row do |row|
      name = row['name']
      prof = Professor.find_by_fuzzy_name(name)
      if prof.nil?
        prof = Professor.new({:name => name})
        prof.save!
        added_count += 1
      end
      new_profs[row['id']] = prof
    end
    puts "Added #{added_count} new profs"

    added_count = 0
    # tie profs to offerings
    teach_whats.each_row do |row|
      prof = new_profs[row['profid']]
      if prof.nil?
        puts "WARNING: no prof w/ id #{row['profid']}"
        next
      end
      offering = new_offerings[row['courseid']]
      if offering.nil?
        puts "WARNING: no offering for courseid #{row['courseid']}"
      elsif !prof.offerings.include?(offering)
        prof.offerings << offering
        prof.save # TODO does this save do anything? it's many-to-many...
        added_count += 1
      end
    end
    puts "Added #{added_count} new prof/offering pairings"
  end


  def import_reviews
    puts "Importing reviews from CourseGuide..."

    # letters mean: Course, Reviewer, Homework, Exams, Lab, ForeignStudy
    keys = %w{
      coverall cpace cwork cinterest ctas creview cmatchorc cdiversity
      hlearn hhard hinterest
      efair ehard
      loverall lhard ledvalue lreview ltas
      rmajor rneed reffort roffice rattend rterm rhappygrade ryear rnotify
      fsreview
      approved modified note interpretas
      reviewer
      date modifiedat ip hostname lastviewedforedit
      title
    }

    columns = "id, course, #{keys.join(', ')}"

    # puts columns

    use_source
    reviews = ActiveRecord::Base.connection.execute("SELECT #{columns}  FROM reviews;")
    use_target

    puts "CourseGuide has #{reviews.row_count} reviews"
    added_count = 0

    # just wipe the whole table clean before redoing it
    # this is the only thing that touches this table anyways
    OldReview.delete_all

    reviews.each_row do |row|
      # skip if the review already exists
      # next if OldReview.find_by_old_id(row['id'])

      attrs = {:old_id => row['id'], :old_offering_id => row['course']}
      keys.each {|key| attrs[key] = row[key]}
      review = OldReview.new(attrs)
      if !review.save
        puts "Trouble saving review for old_id #{review.old_id}: #{review.attributes}"
      else
        added_count += 1
      end
    end

    # puts "Added #{added_count} new reviews."
  end
end

class Row
  # column_names: name => column_index hash
  # values: row values
  def initialize(column_names, values)
    @indexes = column_names
    @values = values
  end

  def [](key)
    @values[@indexes[key]]
  end
end

class Mysql2::Result
  # horrifying side-effect: self.count CHANGES VALUE when called multiple times
  # and is only right the first time. so you can only call each_row once
  @num_rows = nil
  def row_count
    @num_rows = self.count if @num_rows.nil?
    @num_rows
  end

  def each_row
    column_names = Hash[self.fields.each_with_index.to_a]
    a = self.to_a
    if block_given?
      (0...row_count).each {|i| yield Row.new(column_names, a[i].to_a) }
    else # no block, so just return an enumerable
      return (0...row_count).map {|i| Row.new(column_names, a[i].to_a) }
    end
  end
end