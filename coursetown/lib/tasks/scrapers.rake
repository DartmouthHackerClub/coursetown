namespace :scrape do
  task :timetable => :environment do
    filename = '../scrapers/timetable/timetable.json'
    File.open(filename, 'r') do |f|
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
        }
        if not c.offerings.find(:first, :conditions => offering_info)
          o = Offering.create(offering_info) 
          o.courses << c
          o.save()
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
