# == Schema Information
#
# Table name: menu_groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  menu_id     :uuid             not null
#  order       :integer
#  creator_id  :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do

  factory :menu_group do
    text { "Menu Group #{MenuGroup.count}" }
    description { "#{text.sub(' Group','')} test menu group" }
    domain { create(:domain, text: "#{text.sub(' Group','')}") }
    domain_id { domain.present? ? domain.id : nil }
    menu { create(:menu, text: "Menu for #{text}", domain: domain) }
    menu_id { menu.present? ? menu.id : nil }
    order { MenuGroup.count }
    creator { create(:user) }
    creator_id { creator.present? ? creator.id : nil}
  end

end
