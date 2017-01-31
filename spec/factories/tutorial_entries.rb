# == Schema Information
#
# Table name: published_entries
#
#  id         :uuid             not null, primary key
#  author_id  :uuid             not null
#  domain_id  :uuid             not null
#  entry_id   :uuid             not null
#  image_url  :string
#  notes      :text
#  tags       :text             is an Array
#  type       :string
#  data       :json
#  creator_id :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :tutorial_entry do
    entry { create(:entry_with_creator) }
    entry_id { entry.id }
    author { entry.author }
    author_id { author.id }
    domain { create(:domain) }
    domain_id { domain.id }
    notes "Notes for entry"
    tags ['tag_a', 'tag_b']
    data { {order: TutorialEntry.count} }
    creator { entry.author }
  end
end
