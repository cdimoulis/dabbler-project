# == Schema Information
#
# Table name: group_topic_published_entries
#
#  id                 :uuid             not null, primary key
#  group_id           :uuid             not null
#  topic_id           :uuid
#  published_entry_id :uuid             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :group_topic_published_entry do
    domain { create(:domain) }
    group { create(:featured_group, domain: domain) }
    group_id { group.id }
    topic { create(:topic, group: group, domain: domain) }
    topic_id { topic.id }
    published_entry { create(:featured_entry, domain: group.domain) }
    published_entry_id { published_entry.id }
  end
end
