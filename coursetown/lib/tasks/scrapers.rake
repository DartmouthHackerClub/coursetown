namespace :scrape do
  task :departments => :environment do
    filename = File.expand_path(File.dirname(__FILE__) + '/../../public/scripts/dept_map.csv')
    open(filename).each do |line|
      abbr, id, name = line.gsub('"', '').split ';'
      Department.create({:abbr => abbr, :name => name})
    end
  end

  task :orc => :environment do
    filename = '../scrapers/orc/course_set.json'
    Offering.transaction {
      File.open(filename, 'r') { |f|
        puts "loading the ORC JSON..."
        data = JSON.parse(f.read)
        puts "done."
        puts "importing data into db (#{data['courses'].count} courses)..."
        data['courses'].each { |course|
          course_info = {
            :desc => course["description"],
            :long_title => course["title"]
          }
          # unused:
          #   course["note"] #ex "Identical to Latin American  and Caribbean Studies 4"
          #   course["instances"]
          #   course["section"]
          #   course["offered"] #ex: "11W: 10 12W: 10A"
          #   course["distribs"] #ex: ["LIT"]
          #   course["wcults"] #ex["NW"] 
          #   course["profs"] #ex [["Rodolfo A. Franconi"],["Beatriz Pastor","11W"],["Buéno"]
          c = Course.find_or_initialize_by_department_and_number(course['subject'], course['number'])
          c.update_attributes(course_info)
        }
      }
    }
    puts "done: import finished. (#{Course.count} courses total)"
  end
  task :timetable => :environment do
    filename = '../scrapers/timetable/timetable_test_data.json'
    #TODO: DEBUG
    #filename = '../scrapers/timetable/timetable.json'

    File.open(filename, 'r') do |f|
      puts "loading timetable JSON..." 
      data = JSON.parse(f.read)
      puts "done."
      puts "importing data into db (#{data.size} offerings)..."
      data.each { |offering|
        course_info = {
          #:department => offering['Subj'],
          #:number => offering['Num'],
          :short_title => offering['Title']
        }

        c = Course.find_or_initialize_by_department_and_number(offering['Subj'], offering['Num'])
        if !c.update_attributes(course_info) # saves to DB
          puts "Course [#{c.compact_title}] is invalid!"
        end

        ### THE OFFERING
        month_quarter_mappings = {
          '01' => 'W',
          '09' => 'F',
          '03' => 'S',
          '06' => 'X',
        }
        offering_info = {
          :time => offering['Period'],
          :wc => offering['WC'],
          :building => offering['Building'],
          :room => offering['Room'],
          :enrollment_cap => offering['Lim'],
          :enrolled => offering['Enrl']
        }
        year = offering['Term'][0,4]
        term = month_quarter_mappings[offering['Term'][4,6]]
        # Unused fields:
        #   offering['Status'] ex: "IP" for "In Progress"
        #   offering['Xlist'] ex: "WGST 034 02"

        # TODO it'd be great to be able to say:
        #   o = c.offerings.find_or_create_by_year_and_term_and_section(year,term,offering['Sec'])
        #   o.update_attributes(offering_info)
        # but that creates duplicates! so let's be explicit
        o = c.offerings.find_by_year_and_term_and_section(year, term, offering['Sec'])
        if o.nil?
          o = Offering.new(offering_info)
          o.year = year
          o.term = term
          o.section = offering['Sec']
          o.save
          c.offerings << o
        else
          o.update_attributes(offering_info)
        end

        distribs = offering['Dist'].strip.upcase.split(' OR ')
        distribs.each {|d| o.distribs.find_or_create_by_distrib_abbr(d)}
        professor_names = offering['Instructor'].split(', ')
        professor_names.each { |name|
          if o.professors.find_by_name(name).nil?
            o.professors << Professor.find_or_create_by_name(name)
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
