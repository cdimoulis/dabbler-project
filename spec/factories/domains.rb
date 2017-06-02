# == Schema Information
#
# Table name: domains
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  subdomain   :string           not null
#  active      :boolean          default(TRUE)
#  creator_id  :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
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

    # Domain with :featured_groups populated
    factory :domain_with_menu_groups do
      # Set the number of menu groups
      transient do
        groups_count 5
      end

      after(:create) do |domain, evaluator|
        # Domain Group names must be different within same domain
        (1..evaluator.groups_count).step(1) do |i|
          create(:menu_group, text: "#{domain.text} #{i} Menu Group", domain: domain)
        end
      end
    end
  end
end
