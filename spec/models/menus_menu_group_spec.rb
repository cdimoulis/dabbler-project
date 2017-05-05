# == Schema Information
#
# Table name: menus_menu_groups
#
#  id            :uuid             not null, primary key
#  menu_id       :uuid             not null
#  menu_group_id :uuid             not null
#

require 'rails_helper'

RSpec.describe MenusMenuGroup, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:menu_group) }
    it { is_expected.to belong_to(:menu) }
  end

  context 'validations' do
    it 'requires unique order' do
      mmg = create(:menus_menu_group)
      menu_group = create(:menu_group, domain: mmg.menu.domain, order: mmg.menu_group.order)
      mmg_new = build(:menus_menu_group, menu_group: menu_group)
      expect(mmg_new.valid?).to be_falsy
    end

    it 'unique order only applies to type' do
      mmg = create(:menus_menu_group)
      menu = create(:menu, domain: mmg.menu.domain)
      menu_group = create(:menu_group, domain: mmg.menu.domain, order: mmg.menu_group.order)
      mmg_new = build(:menus_menu_group, menu: menu, menu_group: menu_group)
      expect(mmg_new.valid?).to be_truthy
    end

    it 'requires domain to match' do
      menu = create(:menu)
      group = create(:menu_group)
      mmg = build(:menus_menu_group, menu: menu, menu_group: group)
      expect(mmg.valid?).to be_falsy
    end

    it 'requires MenuGroup type only' do
      group = create(:featured_group)
      menu = create(:menu, domain: group.domain)
      mmg = build(:menus_menu_group, menu_group_id: group.id, menu_id: menu.id)
      expect(mmg.valid?).to be_falsy
    end
  end
end
