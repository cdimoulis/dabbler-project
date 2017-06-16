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

### TEST Domain

test_domain = Domain.create(
  text: 'Test',
  description: 'Test domain',
  subdomain: 'test',
  creator_id: user.id
)

Menu.create [
  {text: 'TEST Menu A', domain: test_domain, creator: user},
  {text: 'TEST Menu B', domain: test_domain, creator: user},
  {text: 'TEST Menu C', domain: test_domain, creator: user, order: 1},
  {text: 'TEST Menu D', domain: test_domain, creator: user, order: 2},
  {text: 'TEST Menu E', domain: test_domain, creator: user, order: 3},
  {text: 'TEST Menu F', domain: test_domain, creator: user}
]

ma = Menu.where(text: 'TEST Menu A').take
mb = Menu.where(text: 'TEST Menu B').take

MenuGroup.create [
  {text: 'MenuGroup 1', menu: ma, creator: user},
  {text: 'MenuGroup 2', menu: ma, creator: user},
  {text: 'MenuGroup 3', menu: ma, creator: user},
  {text: 'MenuGroup 1', menu: mb, creator: user},
  {text: 'MenuGroup 2', menu: mb, creator: user}
]

### END TEST Domain

### DEMO Domain

demo_domain = Domain.create(
  text: 'Demo',
  description: 'Demo domain',
  subdomain: 'demo',
  creator_id: user.id
)

Menu.create [
  {text: 'DEMO Menu A', domain: demo_domain, creator: user},
  {text: 'DEMO Menu B', domain: demo_domain, creator: user},
  {text: 'DEMO Menu C', domain: demo_domain, creator: user, order: 1},
  {text: 'DEMO Menu D', domain: demo_domain, creator: user, order: 2},
  {text: 'DEMO Menu E', domain: demo_domain, creator: user, order: 3},
  {text: 'DEMO Menu F', domain: demo_domain, creator: user}
]

ma = Menu.where(text: 'DEMO Menu A').take
mb = Menu.where(text: 'DEMO Menu B').take

MenuGroup.create [
  {text: 'MenuGroup a', menu: ma, creator: user},
  {text: 'MenuGroup b', menu: ma, creator: user},
  {text: 'MenuGroup c', menu: ma, creator: user},
  {text: 'MenuGroup a', menu: mb, creator: user},
  {text: 'MenuGroup b', menu: mb, creator: user}
]

### END DEMO Domain

puts "\n\nEnd seeding database with test data\n"
