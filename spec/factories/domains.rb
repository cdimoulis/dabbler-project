# == Schema Information
#
# Table name: domains
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  subdomain   :string           not null
#  active      :boolean          default(TRUE)
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

    # Domain with :domain_groups populated
    factory :domain_with_groups do
      # Set the number of groups
      transient do
        domain_groups_count 5
      end

      after(:create) do |domain, evaluator|
        # Domain Group names must be different within same domain
        (1..evaluator.domain_groups_count).step(1) do |i|
          create(:domain_group, text: "#{domain.text} #{i} Group", domain: domain)
        end
      end
    end
  end

end
