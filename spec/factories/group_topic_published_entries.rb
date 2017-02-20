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
    transient do
      domain { create(:domain) }
      domain_id { domain.present? ? domain.id : nil }
    end

    group { create(:featured_group, domain: domain) }
    group_id { group.present? ? group.id : nil }
    topic { create(:topic, group: group, domain: domain) }
    topic_id { topic.present? ? topic.id : nil }
    published_entry { create(:featured_entry, domain: group.domain) }
    published_entry_id { published_entry.present? ? published_entry.id : nil }
  end
end
