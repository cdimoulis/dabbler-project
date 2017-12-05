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
  {text: 'MenuGroup 2', menu: ma, creator: user, order: 1},
  {text: 'MenuGroup 3', menu: ma, creator: user, order: 2},
  {text: 'MenuGroup 1', menu: mb, creator: user},
  {text: 'MenuGroup 2', menu: mb, creator: user}
]

mg_1 = MenuGroup.where(text: 'MenuGroup 1', menu_id: ma.id).take
mg_2 = MenuGroup.where(text: 'MenuGroup 2', menu_id: mb.id).take

Topic.create [
  {text: 'Topic 1', menu_group: mg_1, creator: user, published_entry_ordering: ['order:asc']},
  {text: 'Topic 2', menu_group: mg_1, creator: user, order: 1},
  {text: 'Topic 3', menu_group: mg_1, creator: user, order: 2},
  {text: 'Topic 1', menu_group: mg_2, creator: user},
  {text: 'Topic 2', menu_group: mg_2, creator: user}
]

e1 = Entry.create(text: 'Entry 1', author: user, content: 'TEST Entry', creator: user)
e2 = Entry.create(text: 'Entry 2', author: user, content: 'TEST Entry', creator: user)
e3 = Entry.create(text: 'Entry 3', author: user, content: 'TEST Entry', creator: user)
e4 = Entry.create(text: 'Entry 4', author: user, content: 'TEST Entry', creator: user)
e5 = Entry.create(text: 'Entry 5', author: user, content: 'TEST Entry', creator: user)
e6 = Entry.create(text: 'Entry 6', author: user, content: 'TEST Entry', creator: user)

# Create an updated entry
e4.updated_entry_id = e5.id
e4.save

pe1 = PublishedEntry.create(domain: test_domain, entry: e1, notes: e1.text, creator: user, published_at: DateTime.parse('2017-06-06').to_s, type: 'PublishedEntry')
pe2 = PublishedEntry.create(domain: test_domain, entry: e2, notes: e2.text, creator: user, published_at: DateTime.parse('2017-06-05').to_s, type: 'PublishedEntry')
pe3 = PublishedEntry.create(domain: test_domain, entry: e3, notes: e3.text, creator: user, published_at: DateTime.parse('2017-06-04').to_s, type: 'PublishedEntry')
pe4 = PublishedEntry.create(domain: test_domain, entry: e5, notes: e5.text, creator: user, published_at: DateTime.parse('2017-06-03').to_s, type: 'PublishedEntry')

topic = Topic.where(text: 'Topic 1', menu_group_id: mg_1.id).take

PublishedEntriesTopic.create [
  {published_entry: pe1, topic: topic, creator_id: user.id},
  {published_entry: pe2, topic: topic, creator_id: user.id},
  {published_entry: pe3, topic: topic, order: 1, creator_id: user.id},
  {published_entry: pe4, topic: topic, order: 2, creator_id: user.id}
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
  {text: 'MenuGroup b', menu: ma, creator: user, order: 1},
  {text: 'MenuGroup c', menu: ma, creator: user, order: 2},
  {text: 'MenuGroup a', menu: mb, creator: user},
  {text: 'MenuGroup b', menu: mb, creator: user}
]

mg_1 = MenuGroup.where(text: 'MenuGroup a', menu_id: ma.id).take
mg_2 = MenuGroup.where(text: 'MenuGroup b', menu_id: mb.id).take

Topic.create [
  {text: 'Topic a', menu_group: mg_1, creator: user},
  {text: 'Topic b', menu_group: mg_1, creator: user, order: 1},
  {text: 'Topic c', menu_group: mg_1, creator: user, order: 2},
  {text: 'Topic a', menu_group: mg_2, creator: user},
  {text: 'Topic b', menu_group: mg_2, creator: user}
]

e1 = Entry.create(text: 'Entry a', author: user, content: 'TEST Entry', creator: user)
e2 = Entry.create(text: 'Entry b', author: user, content: 'TEST Entry', creator: user)
e3 = Entry.create(text: 'Entry c', author: user, content: 'TEST Entry', creator: user)
e4 = Entry.create(text: 'Entry d', author: user, content: 'TEST Entry', creator: user)
e5 = Entry.create(text: 'Entry e', author: user, content: 'TEST Entry', creator: user)
e6 = Entry.create(text: 'Entry f', author: user, content: 'TEST Entry', creator: user)

# Create an updated entry
e4.updated_entry_id = e5.id
e4.save

pe1 = PublishedEntry.create(domain: demo_domain, entry: e1, notes: e1.text, creator: user, published_at: DateTime.parse('2017-06-06').to_s, type: 'PublishedEntry')
pe2 = PublishedEntry.create(domain: demo_domain, entry: e2, notes: e2.text, creator: user, published_at: DateTime.parse('2017-06-05').to_s, type: 'PublishedEntry')
pe3 = PublishedEntry.create(domain: demo_domain, entry: e3, notes: e3.text, creator: user, published_at: DateTime.parse('2017-06-04').to_s, type: 'PublishedEntry')
pe4 = PublishedEntry.create(domain: demo_domain, entry: e5, notes: e5.text, creator: user, published_at: DateTime.parse('2017-06-03').to_s, type: 'PublishedEntry')

topic = Topic.where(text: 'Topic a').take

PublishedEntriesTopic.create [
  {published_entry: pe1, topic: topic, creator_id: user.id},
  {published_entry: pe2, topic: topic, creator_id: user.id},
  {published_entry: pe3, topic: topic, order: 1, creator_id: user.id},
  {published_entry: pe4, topic: topic, order: 2, creator_id: user.id}
]

### END DEMO Domain

puts "\n\nEnd seeding database with test data\n"
