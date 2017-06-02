# == Schema Information
#
# Table name: topics
#
#  id            :uuid             not null, primary key
#  text          :string           not null
#  description   :text
#  domain_id     :uuid             not null
#  menu_group_id :uuid             not null
#  creator_id    :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do

  factory :topic do
    text { "Topic #{Topic.count + 1}" }
    description { "#{text} test topic" }
    domain { create(:domain) }
    domain_id { domain.present? ? domain.id : nil }
    menu_group { create(:menu_group, domain: domain) }
    menu_group_id { menu_group.present? ? menu_group.id : nil }
    creator { create(:user) }
    creator_id { creator.present? ? creator.id : nil }

    factory :topic_without_domain do
      domain nil
      domain_id nil
      menu_group { create(:menu_group) }
      menu_group_id { menu_group.present? ? menu_group.id : nil }
    end

    factory :topic_without_menu_group do
      menu_group nil
      menu_group_id nil
    end
  end

end
