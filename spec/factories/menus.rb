# == Schema Information
#
# Table name: menus
#
#  id               :uuid             not null, primary key
#  text             :string           not null
#  description      :text
#  domain_id        :uuid             not null
#  order            :integer          not null
#  menu_group_order :string           default("text")
#  creator_id       :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do

  factory :menu do
    text { "Menu #{Menu.count}" }
    description { "A description for #{text}" }
    domain { create(:domain) }
    domain_id { domain.present? ? domain.id : nil }
    order { Menu.count }
    menu_group_order 'text'
  end

end
