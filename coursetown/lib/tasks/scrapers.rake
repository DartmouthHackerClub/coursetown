namespace :scrape do
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
