# == Schema Information
#
# Table name: published_entries_topics
#
#  id                 :uuid             not null, primary key
#  published_entry_id :uuid
#  topic_id           :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :published_entries_topic do
    
  end
end
