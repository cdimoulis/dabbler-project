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
  factory :featured_entry do
    entry { create(:entry_with_creator) }
    author { entry.author }
    domain { create(:domain) }
    notes "Notes for entry"
    tags ['tag_a', 'tag_b']
    data { {published_at: DateTime.now} }
    creator { entry.author }
  end
end
