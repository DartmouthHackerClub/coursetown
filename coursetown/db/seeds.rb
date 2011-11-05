# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def professorize(prof_names)
  return prof_names.map{|x| Professor.find_or_create_by_name(x)}
end

courses = Course.create([
  {department: 'COSC', number: 5, long_title: 'Introduction'},
  {department: 'MATH', number: 22, long_title: 'Linear Algebra'},
  {department: 'WIZD', number: 17, long_title: 'Care of Magical Creatures'},
  {department: 'WIZD', number: 43, long_title: 'Defense Against the Dark Arts'}])

users = User.create([{name: "Octavius Ott", year: 2012}, {name: "Cindy Ott", year: 2013}, {name: "John Ledyard", year: 2014}])

offerings = Offering.create([
  {courses: [courses[0]], year: 2011, term: 'F', professors: professorize(['Scott Drysdale']), time: "10A"},
  {courses: [courses[0]], year: 2011, term: 'W', professors: professorize(['Chris Bailey-Kellogg']), time: "2"},
  {courses: [courses[1]], year: 2011, term: 'F', professors: professorize(['Mathface McMath']), time: "2"},
  {courses: [courses[1]], year: 2011, term: 'F', professors: professorize(['Shelly Algebra']), time: "10"},
  {courses: [courses[2]], year: 2011, term: 'F', professors: professorize(['Haggar the Horrible']), time: "8"},
  {courses: [courses[2]], year: 2011, term: 'W', professors: professorize(['Haggar the Horrible']), time: "8"}])

Wishlist.create([
  {user: users[0], course: courses[1]},
  {user: users[0], course: courses[3]},
  {user: users[2], course: courses[1]}])

Schedule.create([
  {user_id: users[0].id, offering_id: offerings[0].id}, {user_id: users[0].id, offering_id: offerings[2].id},
  {user_id: users[2].id, offering_id: offerings[1].id}, {user_id: users[2].id, offering_id: offerings[3].id}])

Distrib.create([
  {:offering_id => 1, :distrib_name => "Literature", :distrib_abbr => "Lit"},
  {:offering_id => 3, :distrib_name => "Sociology", :distrib_abbr => "Soc"}
])