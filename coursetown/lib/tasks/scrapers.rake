namespace :scrape do
  task :departments => :environment do
    filename = File.expand_path(File.dirname(__FILE__) + '/../../public/scripts/dept_map.csv')
    open(filename).each do |line|
      abbr, id, name = line.gsub('"', '').split ';'
      Department.create({:abbr => abbr, :name => name})
    end
  end

  task :orc => :environment do
    num_new = 0
    filename = '../scrapers/orc.json'
    Offering.transaction {
      File.open(filename, 'r') { |f|
        puts "loading the ORC JSON..."
        data = JSON.parse(f.read)
        puts "done."
        puts "importing data into db (#{(data['records'] || []).count} courses)..."
        data['records'].each { |course|
          # unused:
          #   course["note"] #ex "Identical to Latin American  and Caribbean Studies 4"
          #   course["instances"]
          #   course["section"]
          #   course["offered"] #ex: "11W: 10 12W: 10A"
          #   course["distribs"] #ex: ["LIT"]
          #   course["wcults"] #ex["NW"]
          #   course["profs"] #ex [["Rodolfo A. Franconi"],["Beatriz Pastor","11W"],["Buéno"]
          c = Course.find_or_initialize_by_department_and_number(course['subject'], course['number'])

          # mass-assignment doesn't work in prod! have to manually assign
          c.desc = course['description']
          c.long_title = course['title']
          num_new += 1 if c.save

          # TODO: add wcult & distribs to the course's offerings
        }
      }
    }
    puts "done: import finished. Updated #{num_new} courses. (#{Course.count} total)"
  end
  task :timetable => :environment do
    filename = '../scrapers/timetable.json'
    #TODO: DEBUG
    #filename = '../scrapers/timetable/timetable.json'

    courses_count = 0
    offerings_count = 0

    File.open(filename, 'r') do |f|
      puts "loading timetable JSON..."
      data = JSON.parse(f.read)
      puts "done."
      puts "importing data into db (#{data.size} offerings)..."

      all_distribs = Set.new(Distrib.all_abbrs.to_a)
      month_quarter_mappings = {'01' => 'W','09' => 'F','03' => 'S','06' => 'X'}

      data.each { |offering|
        course_info = {
          #:department => offering['Subj'],
          #:number => offering['Num'],
          :short_title => offering['Title']
        }

        ### THE COURSES
        # x-listed courses AND canonical course
        courses = offering['Xlist'].split(',').map{|str| str.split(' ')}
        courses << [offering['Subj'], offering['Num']]
        courses.map! do |dept, num, section|
          if dept.nil? || num.nil?
            puts "SCRAPE ERROR: Invalid course identifier in offering: #{offering}\n"
            next nil
          end
          c = Course.find_or_initialize_by_department_and_number(dept, num)

          c.short_title = offering['Title'] if offering['Title'].present?

          if !c.save
            puts "Course [#{c.compact_title}] is invalid!"
          else
            courses_count += 1
          end
          c
        end
        # check that at least one course saved correctly
        if courses.all?{|c| c.nil?}
          puts "Saved NO valid courses for this offering! Skipping."
          next
        end

        ### THE OFFERING
        year = offering['Term'][0,4]
        term = month_quarter_mappings[offering['Term'][4,6]]
        section = offering['Sec']
        # Unused fields:
        #   offering['Status'] ex: "IP" for "In Progress"
        #   offering['Xlist'] ex: "WGST 034 02"
        # Dist, ex: 'INT or SOC'

        # because we're going through a join table, we need to save our new object
        # BEFORE adding connections
        #   o = c.offerings.find_or_create_by_year_and_term_and_section(year,term,offering['Sec'])
        #   o.update_attributes(offering_info)
        # but that creates duplicates! so let's be explicit

        o = courses.map{|c|
          c.offerings.find_by_year_and_term_and_section(year, term, section)
        }.select{|x| x}.first # filter out nils
        if o.nil?
          o = Offering.new({:year => year, :term => term, :section => section})
        end
        # update attributes only if you're writing a real value
        v = nil
        o.time = v            if (v = offering['Period']).present?
        o.wc = v              if (v = offering['WC']).present?
        o.building = v        if (v = offering['Building']).present?
        o.room = v            if (v = offering['Room']).present?
        o.enrollment_cap = v  if (v = offering['Lim']).present?
        o.enrolled = v        if (v = offering['Enrl']).present?
        o.specific_title = v  if (v = offering['Title']).present?
        o.courses |= courses # add any courses to the offering that weren't already

        if o.save
          offerings_count += 1
        else
          puts "ERROR SAVING RECORD: \n#{o.attributes}\nfrom:\n#{offering}"
        end


        ### DISTRIBS
        distrib_str = offering['Dist'] || ''
        distrib_abbrs = distrib_str.split(' ').select{|d| Distrib.is_abbr?(d.upcase!)}
        distrib_abbrs.each { |d| o.distribs.find_or_create_by_distrib_abbr(d) }

        ### PROFESSORS
        professor_names = offering['Instructor'].split(', ')
        professor_names.each { |name|
          # use custom finder, find_by_fuzzy_name, to find the professor in the
          # db, even if her name is in a different form
          # e.g. Jane A. Doe III vs. Jane Doe
          if Professor.find_by_fuzzy_name(name, o.professors).nil?
            o.professors << Professor.find_or_create_by_fuzzy_name(name)
          end
        }
      }
      puts "done: import finished. (#{Offering.count} offerings total)"
    end
  end
#  task :nro => :environment {
#    year = 2011
#    term = "F"
#    
#    filename = '../scrapers/nro/nro.json'
#    File.open(filename, 'r') { |f|
#      data = JSON.parse(f.read)
#      data.each { |dept|
#        puts dept
#        if dept['courses'] == 'all' {
#          courses = Course.find_by_department(dept['department'])
#          if courses {
#            courses.each { |course|
#              course.offerings.where(:year => year, :term => term).each { |offering|
#                offering.nro = false
#                offering.save
#              }
#            }
#          }
#        } else {
#          dept['courses'].each { |course_num|
#            course = Course.find_by_department_and_number(dept['department'], course_num)
#            if course {
#              course.offerings.where(:year => year, :term => term).each { |offering|
#                offering.nro = false
#                offering.save
#              }
#            }
#          }
#        }
#      }
#    }
#  }
end
