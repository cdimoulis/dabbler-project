# == Schema Information
#
# Table name: groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  order       :integer          not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do

  factory :tutorial_group do
    text { "Tutorial Group #{TutorialGroup.count} " }
    description { "#{text.sub(' Group','')} test tutorial group" }
    domain { create(:domain) }
    domain_id { domain.id }
    order { TutorialGroup.count }
  end
end
