# == Schema Information
#
# Table name: domain_groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Factory for
#   Domain model
FactoryGirl.define do

  factory :domain_group do
    text { "Domain Group #{DomainGroup.count}" }
    description { "#{text.sub(' Group','')} test domain group" }
    domain { create(:domain) }
  end
end
