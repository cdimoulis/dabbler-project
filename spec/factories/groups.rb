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
    text { "Group #{Group.count} " }
    description { "#{text} test group" }
    domain { create(:domain) }
    type "DomainGroup"
  end

end
