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

  factory :menu_group do
    text { "Menu Group #{MenuGroup.count}" }
    description { "#{text.sub(' Group','')} test menu group" }
    domain { create(:domain, text: "#{text.sub(' Group','')}") }
    domain_id { domain.present? ? domain.id : nil }
    order { MenuGroup.count }
  end

end
