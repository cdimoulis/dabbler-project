# Factory for
#   Domain model
FactoryGirl.define do
  
  factory :domain_travel, class: Domain do
    text 'Travel'
    description 'Travel related Information'
    subdomain 'travel'
  end

  factory :domain_code, class: Domain do
    text 'Code'
    description 'Code related Information'
    subdomain 'code'
  end

  factory :domain_inactive, class: Domain do
    text 'Inactive'
    description 'Inactive domain'
    subdomain 'inactive'
    active false
  end

  factory :domain_unused, class: Domain do
    text 'Unused'
    description 'Unused domain'
    subdomain 'unused'
  end
end
