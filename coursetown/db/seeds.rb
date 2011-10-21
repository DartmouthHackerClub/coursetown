# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

courses = Course.create([{department: 'Computer Science', number: 5, title: 'Introduction'}, {department: 'Mathematics', number: 22, title: 'Linear Algebra'}, {department: 'Wizardry', number: 17, title: 'Care of Magical Creatures'}, {department: 'Wizardry', number: 43, title: 'Defence Against the Dark Arts'}])

Offering.create([{course_id: courses.first.id, year: 2011, term: 'F', professor: 'Scott Drysdale', time: "10A"}, {course_id: courses.first.id, year: 2011, term: 'W', professor: 'Chris Bailey-Kellogg', time: "2"}])

users = Users.create([{name: "Octavius Ott"}, {name: "Cindy Ott"}, {name: "John Ledyard"}])

Wishlists.create([{user_id: users[0], course_id: courses[1]}, {user_id: users[0], course_id: courses[3]}, {user_id: users[2], course_id: courses[2]}, {user_id: users[2], course_id: courses[1]}])