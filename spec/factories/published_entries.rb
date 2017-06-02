# == Schema Information
#
# Table name: published_entries
#
#  id                         :uuid             not null, primary key
#  author_id                  :uuid             not null
#  domain_id                  :uuid             not null
#  entry_id                   :uuid             not null
#  image_url                  :string
#  notes                      :text
#  tags                       :text             is an Array
#  type                       :string
#  data                       :json
#  revised_published_entry_id :uuid
#  removed                    :boolean          default(FALSE)
#  creator_id                 :uuid             not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

FactoryGirl.define do
  factory :published_entry do
    entry { create(:entry) }
    entry_id { entry.present? ? entry.id : nil }
    author { entry.present? ? entry.author : nil }
    author_id { author.present? ? author.id : nil }
    domain { create(:domain) }
    domain_id { domain.present? ? domain.id : nil }
    notes "This entry has some notes"
    tags ['tag_a', 'tag_b']
    type 'PublishedEntry'
    data { {published_at: DateTime.now} }
    creator { entry.present? ? entry.author : nil }
    creator_id { creator.present? ? creator.id : nil }
    revised_published_entry nil
    revised_published_entry_id { revised_published_entry.present? ? revised_published_entry.id : nil }
  end
end
