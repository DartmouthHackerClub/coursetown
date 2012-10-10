require 'json'

class Scraper
  def import_nro
    year = 2011
    term = "F"

    filename = 'nro.json'
    File.open(filename, 'r') do |f|
      data = JSON.parse(f.read)
      data.each do |dept|
        dept['courses'].each do |course_num|
          Course.find_by_department_and_number(dept, course_num).offerings.where(:year => year, :term => term).each do |offering|
            offering.nro = false
          end
        end
      end
    end
  end
end
