# Factory for
#   Domain model
FactoryGirl.define do

  factory :domain do
    text "Test"
    description { "#{text} domain" }
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
