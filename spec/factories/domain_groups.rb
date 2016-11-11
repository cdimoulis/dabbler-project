# Factory for
#   Domain model
FactoryGirl.define do

  factory :domain_group do
    text "Test Group"
    description { "#{text.sub(' Group','')} domain group" }
    domain
  end
end
