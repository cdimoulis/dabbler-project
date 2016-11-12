# Factory for
#   Domain model
FactoryGirl.define do

  factory :domain_group do
    text "Test Group"
    description { "#{text.sub(' Group','')} domain group" }
    created_at { DateTime.now.to_date.to_time }
    updated_at { DateTime.now.to_date.to_time }
    domain { create(:domain, text: "#{text.sub(' Group','')}" ) } 
  end
end
