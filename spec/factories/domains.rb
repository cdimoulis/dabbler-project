# == Schema Information
#
# Table name: domains
#
#  id            :uuid             not null, primary key
#  text          :string           not null
#  description   :text
#  subdomain     :string           not null
#  active        :boolean          default(TRUE)
#  menu_ordering :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  creator_id    :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# Factory for
#   Domain model
FactoryGirl.define do

  factory :domain do
    text { "Domain #{Domain.count + 1}" }
    description { "#{text} test domain" }
    subdomain { text.downcase }
    active true
    creator { create(:user) }
    creator_id { creator.present? ? creator.id : nil}

    # Domain with :menu_groups populated
    factory :domain_with_menu_groups do
      # Set the number of menu groups
      transient do
        menu_groups_count 5
      end

      after(:create) do |domain, evaluator|
        # Domain Group names must be different within same domain
        (1..evaluator.menu_groups_count).step(1) do |i|
          create(:menu_group_with_domain, domain: domain)
        end
      end
    end

    # Domain with :topics populated
    factory :domain_with_topics do
      # Set the number of menu groups
      transient do
        topics_count 5
      end

      after(:create) do |domain, evaluator|
        # Domain Group names must be different within same domain
        (1..evaluator.topics_count).step(1) do |i|
          create(:topic_with_domain, domain_id: domain.id)
        end
      end
    end
  end
end
