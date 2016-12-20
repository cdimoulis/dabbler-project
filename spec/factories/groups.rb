# == Schema Information
#
# Table name: groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Factory for
#   Domain model
FactoryGirl.define do

  factory :group do
    text "Test Group"
    description { "#{text.sub(' Group','')} domain group" }
    domain { create(:domain, text: "#{text.sub(' Group','')}" ) }
    type "DomainGroup"
    # created_at { DateTime.now.to_date.to_time }
    # updated_at { DateTime.now.to_date.to_time }
  end

end
