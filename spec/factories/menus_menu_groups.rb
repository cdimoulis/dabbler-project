# == Schema Information
#
# Table name: menus_menu_groups
#
#  id            :uuid             not null, primary key
#  menu_id       :uuid             not null
#  menu_group_id :uuid             not null
#

FactoryGirl.define do
  factory :menus_menu_group do
    menu { create(:menu) }
    menu_id { menu.present? ? menu.id : nil }
  end
end
