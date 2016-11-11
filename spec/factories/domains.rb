# Factory for
#   Domain model
FactoryGirl.define do

  factory :domain do
    text "Empty"
    description { "#{text} domain" }
    subdomain { text.downcase }
  end
  
end
