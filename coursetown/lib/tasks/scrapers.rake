namespace :scrape do
  task :timetable => :environment do
    filename = '../scrapers/timetable/timetable.json'
    Offering.transaction do 
    File.open(filename, 'r')do |f|
      puts "loading the JSON..." 
      data = JSON.parse(f.read)
      puts "done."
      data.each do |offering|
        course_info = {
          :department => offering['Subj'],
          :number => offering['Num'],
          :short_title => offering['Title']
          }
        c = Course.find(:first, :conditions => course_info) || Course.create(course_info) 
        c.save()
        month_quarter_mappings = {
          '01' => 'W',
          '09' => 'F',
          '03' => 'S',
          '06' => 'X',
          }
        offering_info = {
          :year => offering['Term'][0,4],
          :term => month_quarter_mappings[offering['Term'][4,6]],
          #:crn
          :time => offering['Period'],
          :wc => offering['WC'],
          :section => offering['Sec'],
          #:building => offering['Building'],
          #:room => offering['Room'],
          #:enrollment_cap => offering['Lim']
          #:enrolled => offering['Enrl']
          }
        # Unused fields:
        #   offering['Status'] ex: "IP" for "In Progress"
        #   offering['Xlist'] ex: "WGST 034 02"
        o = c.offerings.find(:first, :conditions => offering_info)
        if not o
          o = Offering.create(offering_info) 
          o.courses << c
          o.save()
        end
        professor_names = offering['Instructor'].split(', ')
        professor_names.each do |professor_name|
          prof_info = {:name => professor_name}
          p = Professor.find(:first, :conditions => prof_info) || Professor.create(prof_info)
          if not o.professors.index(p) ##there's probably a better way to do this...
            o.professors << p
          end
        end
      end
    end
  end
  task :nro => :environment do
    year = 2011
    term = "F"
    
    filename = '../scrapers/nro/nro.json'
    File.open(filename, 'r') do |f|
      data = JSON.parse(f.read)
      data.each do |dept|
        puts dept
        if dept['courses'] == 'all'
          courses = Course.find_by_department(dept['department'])
          if courses
            courses.each do |course|
              course.offerings.where(:year => year, :term => term).each do |offering|
                offering.nro = false
                offering.save
              end
            end
          end
        else
          dept['courses'].each do |course_num|
            course = Course.find_by_department_and_number(dept['department'], course_num)
            if course
              course.offerings.where(:year => year, :term => term).each do |offering|
                offering.nro = false
                offering.save
              end
            end
          end
        end
      end
    end
    end	
  end
end  
