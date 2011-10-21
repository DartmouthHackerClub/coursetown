# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

courses = Course.create([{department: 'Computer Science', number: 5, title: 'Introduction'}, {department: 'Mathematics', number: 22, title: 'Linear Algebra'}])

Offering.create([{course_id: courses.first.id, year: 2011, term: 'F', professor: 'Scott Drysdale', time: "10A"}, {course_id: courses.first.id, year: 2011, term: 'W', professor: 'Chris Bailey-Kellogg', time: "2"}])
