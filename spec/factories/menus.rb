# == Schema Information
#
# Table name: menus
#
#  id                  :uuid             not null, primary key
#  text                :string           not null
#  description         :text
#  domain_id           :uuid             not null
#  order               :integer
#  menu_group_ordering :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  creator_id          :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do

  factory :menu do
    text { "Menu #{Menu.count}" }
    description { "A description for #{text}" }
    domain { create(:domain) }
    domain_id { domain.present? ? domain.id : nil }
    order { Menu.count }
    creator { create(:user) }
    creator_id { creator.present? ? creator.id : nil}

    # Domain with :topics populated
    factory :menu_with_topics do
      # Set the number of menu groups
      transient do
        topics_count 5
      end

      after(:create) do |menu, evaluator|
        # Domain Group names must be different within same domain
        (1..evaluator.topics_count).step(1) do |i|
          create(:topic_with_menu, menu_id: menu.id)
        end
      end
    end
  end

end
