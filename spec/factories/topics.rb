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
    group { create(:published_group, domain: domain) }
    creator { create(:user) }

    factory :topic_without_domain do
      domain nil
      group { create(:published_group) }
    end

    factory :topic_without_group do
      group nil
    end
  end

end
