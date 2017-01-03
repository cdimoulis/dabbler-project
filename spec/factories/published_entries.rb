# == Schema Information
#
# Table name: published_entries
#
#  id               :uuid             not null, primary key
#  author_id        :uuid             not null
#  domain_id        :uuid             not null
#  entry_id         :uuid             not null
#  image_url        :string
#  notes            :text
#  tags             :text             is an Array
#  publishable_id   :uuid
#  publishable_type :string
#  creator_id       :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :published_entry do
    entry { create(:entry_with_creator) }
    author { entry.author }
    domain { create(:domain) }
    notes "This entry has some notes"
    tags ['tag_a', 'tag_b']
    creator { entry.author }
  end
end
