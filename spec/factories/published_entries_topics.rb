# == Schema Information
#
# Table name: published_entries_topics
#
#  id                 :uuid             not null, primary key
#  published_entry_id :uuid             not null
#  topic_id           :uuid             not null
#  order              :integer
#  creator_id         :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :published_entries_topic do
    published_entry { create(:published_entry) }
    published_entry_id { published_entry.present? ? published_entry.id : nil }
    topic {
       if published_entry.present?
         create(:topic_with_domain,domain: published_entry.domain)
       else
         create(:topic)
       end
    }
    topic_id { topic.present? ? topic.id : nil }

    factory :published_entries_topic_with_domain do
      transient do
        domain_id nil
        domain { domian_id.present? ? Domain.where("id = ?", domain_id).take : create(:domain) }
      end

      published_entry { create(:published_entry, domain: domain) }
      topic { create(:topic_with_domain, domain: domain) }
    end
  end
end
