# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "\n\nBegin seeding database with test data"

user = User.new(
  email: 'chris@dabblerlabs.com',
  password: 'abcd',
  password_confirmation: 'abcd'
)
user.first_name = 'Chris'
user.last_name = 'Dimoulis'
user.save

domain = Domain.create(
  text: 'Test',
  description: 'Test domain',
  subdomain: 'test',
  creator_id: user.id
)

Menu.create [
  {text: 'Menu A', domain: domain, creator: user},
  {text: 'Menu B', domain: domain, creator: user},
  {text: 'Menu C', domain: domain, creator: user, order: 1},
  {text: 'Menu D', domain: domain, creator: user, order: 2},
  {text: 'Menu E', domain: domain, creator: user, order: 3},
  {text: 'Menu F', domain: domain, creator: user}
]

puts "\n\nEnd seeding database with test data\n"
