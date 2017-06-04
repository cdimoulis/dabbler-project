# == Schema Information
#
# Table name: menu_group_published_entry_topics
#
#  id                 :uuid             not null, primary key
#  menu_group_id      :uuid             not null
#  topic_id           :uuid
#  published_entry_id :uuid             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :menu_group_published_entry_topic do
    transient do
      domain { create(:domain) }
      domain_id { domain.present? ? domain.id : nil }
    end

    menu_group { create(:menu_group, domain: domain) }
    menu_group_id { menu_group.present? ? menu_group.id : nil }
    topic { create(:topic, menu_group: menu_group, domain: domain) }
    topic_id { topic.present? ? topic.id : nil }
    published_entry { create(:published_entry, domain: menu_group.domain) }
    published_entry_id { published_entry.present? ? published_entry.id : nil }
  end
end
