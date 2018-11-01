# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create name: "Yuri Yakymiv", password: "ferrari458", email: "yurithepro@gmail.com"
User.create name: "Michael Yakymiv", password: "ferrari458", email: "michael@jot.com"
User.create name: "Greg Yakymiv", password: "ferrari458", email: "gregyakymiv@jot.com"
User.create name: "Starbucks", password: "VentiNotLarge", email: "joe@starbuck.com"

Event.create!(
  name: "Dart Throwing Competition",
  description: "Throw Darts with the boys",
  address: "127 Street Road",
  lat: 1,
  lng: 2,
  owner: User.find_by_name("Starbucks"),
  start_time: DateTime.current,
  end_time: DateTime.current.advance(day: 1)
)

Event.create!(
  name: "Car meet",
  description: "Show off your dope whip",
  address: "167 Street Road",
  lat: 7,
  lng: 2,
  owner: User.find_by_name("Yuri Yakymiv"),
  start_time: DateTime.current.advance(hour: 2),
  end_time: DateTime.current.advance(hour: 6)
)
