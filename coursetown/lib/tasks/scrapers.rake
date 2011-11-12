namespace :scrape do
  task :orc => :environment do
    filename = '../scrapers/orc/course_set.json'
    Offering.transaction {
      File.open(filename, 'r') { |f|
        puts "loading the ORC JSON..."
        data = JSON.parse(f.read)
        puts "done."
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
          c = Course.find_or_create_by_department_and_number(course['subject'], course['number'])
          c.update_attributes(course_info)
          c.save()
        }
      }
    }
  end
  task :timetable => :environment do
    filename = '../scrapers/timetable/timetable.json'
    Offering.transaction do 
    File.open(filename, 'r')do |f|
      puts "loading timetable JSON..." 
      data = JSON.parse(f.read)
      puts "done."
      data.each do |offering|
        course_info = {
          #:department => offering['Subj'],
          #:number => offering['Num'],
          :short_title => offering['Title']
          }
          c = Course.find_or_create_by_department_and_number(offering['Subj'], offering['Num'])
          c.update_attributes(course_info)
          c.save()
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
            :enrolled => offering['Enrl'],
          }
          year = offering['Term'][0,4]
          term = month_quarter_mappings[offering['Term'][4,6]]
          # Unused fields:
          #   offering['Status'] ex: "IP" for "In Progress"
          #   offering['Xlist'] ex: "WGST 034 02"
          o = c.offerings.find_or_create_by_year_and_term_and_section(year, term, offering['Sec'])
          o.update_attributes(offering_info)
          distribs = offering['Dist'].strip.upcase.split(' OR ')
          distribs.each {|d| o.distribs.find_or_create_by_distrib_abbr(d)}
          professor_names = offering['Instructor'].split(', ')
          professor_names.each { |professor_name|
            o.professors.find_or_create_by_name(professor_name)
          }
          o.save()
        }
      }
    }
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
