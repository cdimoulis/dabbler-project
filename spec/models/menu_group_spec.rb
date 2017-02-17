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

require 'rails_helper'

RSpec.describe MenuGroup, type: :model do

  context 'associations' do
    it { is_expected.to have_one(:menu) }

    # it 'accesses featured_entries' do
    #   group = create(:featured_group)
    #   featured_entry_a = create(:featured_entry, domain: group.domain)
    #   featured_entry_b = create(:featured_entry, domain: group.domain)
    #   featured_entry_c = create(:featured_entry, domain: group.domain)
    #
    #   group.featured_entries << featured_entry_b
    #   group.featured_entries << featured_entry_c
    #   # Change order for sorting scope of featured entries
    #   expect(group.featured_entries).to match([featured_entry_c, featured_entry_b])
    #   join = GroupTopicPublishedEntry.where(group_id: group.id)
    #   expect(join.length).to eq(2)
    # end

    it 'accesses menu' do
      menu = create(:menu)
      menu_group_a = create(:menu_group, domain: menu.domain)
      menu_group_b = create(:menu_group, domain: menu.domain)
      menu_group_a.menu = menu
      menu_group_b.menu = menu
      expect(menu.menu_groups.to_a).to match([menu_group_a, menu_group_b])
    end
  end

  context 'inheritance' do
    it 'type is correct' do
      menu_group = create(:menu_group)
      expect(menu_group.type).to eq('MenuGroup')
    end
  end

  context 'validations' do
    # it 'requires unique order' do
    #   fg_a = create(:featured_group)
    #   fg_b = build(:featured_group, domain: fg_a.domain, order: fg_a.order)
    #   expect(fg_b.valid?).to be_falsy
    # end
    #
    # it 'unique order only applies to type' do
    #   fg_a = create(:featured_group)
    #   fg_b = create(:featured_group, domain: fg_a.domain)
    #   tg = build(:tutorial_group, domain: fg_a.domain, order: fg_a.order)
    #   expect(tg.valid?).to be_truthy
    # end
  end
end
