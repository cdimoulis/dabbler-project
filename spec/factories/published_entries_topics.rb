# == Schema Information
#
# Table name: published_entries_topics
#
#  id                 :uuid             not null, primary key
#  published_entry_id :uuid             not null
#  topic_id           :uuid             not null
#  order              :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :published_entries_topic do
    published_entry { create(:published_entry) }
    published_entry_id { published_entry.present? ? published_entry.id : nil }
    topic {
       if published_entry.present?
         create(:topic, menu_group: create(:menu_group, menu: create(:menu, domain: published_entry.domain)))
       else
         create(:topic)
       end
    }
    topic_id { topic.present? ? topic.id : nil }
  end
end
