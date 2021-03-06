# == Schema Information
#
# Table name: topics
#
#  id                       :uuid             not null, primary key
#  text                     :string           not null
#  description              :text
#  menu_group_id            :uuid             not null
#  order                    :integer
#  published_entry_ordering :text             default(["\"published_at:desc\""]), is an Array
#  creator_id               :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

FactoryGirl.define do

  factory :topic do
    text { "Topic #{Topic.count + 1}" }
    description { "#{text} test topic" }
    menu_group { create(:menu_group) }
    menu_group_id { menu_group.present? ? menu_group.id : nil }
    order { Topic.count }
    creator { create(:user) }
    creator_id { creator.present? ? creator.id : nil }

    factory :topic_without_menu_group do
      menu_group nil
      menu_group_id nil
    end

    factory :topic_with_domain do
      transient do
        domain_id nil
        domain { domain_id.present? ? Domain.where("id = ?", domain_id).take : create(:domain) }
      end

      menu { create(:menu, domain: domain) }
      menu_group { create(:menu_group, menu: menu) }
    end
  end

end
