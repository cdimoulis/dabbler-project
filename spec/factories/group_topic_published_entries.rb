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
    group { create(:group) }
    topic { create(:topic, group: group, domain: group.domain) }
    published_entry { create(:published_entry, domain: group.domain) }

  end
end
