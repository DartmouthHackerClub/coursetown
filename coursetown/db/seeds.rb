# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

courses = Course.create([
  {department: 'COSC', number: 5, title: 'Introduction'},
  {department: 'MATH', number: 22, title: 'Linear Algebra'},
  {department: 'WIZD', number: 17, title: 'Care of Magical Creatures'},
  {department: 'WIZD', number: 43, title: 'Defense Against the Dark Arts'}])

users = User.create([{name: "Octavius Ott"}, {name: "Cindy Ott"}, {name: "John Ledyard"}])

offerings = Offering.create([
  {course_id: courses.first.id, year: 2011, term: 'F', professor: 'Scott Drysdale', time: "10A"},
  {course_id: courses.first.id, year: 2011, term: 'W', professor: 'Chris Bailey-Kellogg', time: "2"},
  {course_id: courses[2].id, year: 2011, term: 'F', professor: 'Hagrid', time: "8"},
  {course_id: courses[2].id, year: 2011, term: 'W', professor: 'Hagrid', time: "8"}])

Wishlist.create([
  {user_id: users[0].id, course_id: courses[1].id}, {user_id: users[0].id, course_id: courses[3].id},
  {user_id: users[2].id, course_id: courses[1].id}])

Schedule.create([
  {user_id: users[0].id, offering_id: offerings[0].id}, {user_id: users[0].id, offering_id: offerings[2].id},
  {user_id: users[2].id, offering_id: offerings[1].id}, {user_id: users[2].id, offering_id: offerings[3].id}])
