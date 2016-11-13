# Factory for
#   Person model
FactoryGirl.define do

  factory :person do
    prefix "Mr."
    first_name "First"
    middle_name "Middle"
    last_name "Last"
    suffix "Jr."
    gender "Male"
    birth_date { 30.years.ago.to_date }
    phone "123-456-78-9012"
    address_one "123 Street Rd."
    city "Chicago"
    state_region "Illinois"
    country "United States"
    postal_code "60061"
    # creator_id => Add when admin association is ready
    created_at { DateTime.now.to_date.to_time }
    updated_at { DateTime.now.to_date.to_time }

  end
end
