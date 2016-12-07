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

  factory :tutorial_group do
    text "Test Tutorial Group"
    description { "#{text.sub(' Group','')} domain group" }
    created_at { DateTime.now.to_date.to_time }
    updated_at { DateTime.now.to_date.to_time }
    domain { create(:domain, text: "#{text.sub(' Group','')}" ) }
  end
end
