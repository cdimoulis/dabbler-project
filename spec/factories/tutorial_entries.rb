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
    entry_id { entry.present? ? entry.id : nil }
    author { entry.present? ? entry.author : nil }
    author_id { author.present? ? author.id : nil }
    domain { create(:domain) }
    domain_id { domain.present? ? domain.id : nil }
    notes "Notes for entry"
    tags ['tag_a', 'tag_b']
    data { {order: TutorialEntry.count} }
    creator { entry.present? ? entry.author : nil }
    creator_id { creator.present? ? creator.id : nil }
    revised_tutorial_entry nil
    revised_published_entry_id { revised_tutorial_entry.present? ? revised_tutorial_entry.id : nil }
  end
end
