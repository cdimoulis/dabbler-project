# == Schema Information
#
# Table name: topics
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  group_id    :uuid             not null
#  creator_id  :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do

  factory :topic do
    text { "Topic #{Topic.count + 1}" }
    description { "#{text} test topic" }
    domain { create(:domain) }
    domain_id { domain.id }
    group { create(:featured_group, domain: domain) }
    group_id { group.id }
    creator { create(:user) }

    factory :topic_without_domain do
      domain nil
      domain_id nil
      group { create(:featured_group) }
      group_id { group.id }
    end

    factory :topic_without_group do
      group nil
      group_id nil
    end
  end

end
