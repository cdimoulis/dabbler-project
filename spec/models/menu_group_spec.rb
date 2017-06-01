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
    it { is_expected.to belong_to(:domain) }
    it { is_expected.to belong_to(:menu) }
    it { is_expected.to have_many(:topics) }
    it { is_expected.to have_many(:menu_group_published_entry_topics) }
    it { expect(MenuGroup.reflect_on_association(:published_entries).macro).to eq(:has_many)}
    it { expect(MenuGroup.reflect_on_association(:published_entries).options[:through]).to eq(:menu_group_published_entry_topics)}

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
    it 'requires unique order' do
      menu = create(:menu)
      mg_a = create(:menu_group, domain: menu.domain)
      mg_a.menu = menu
      mg_b = create(:menu_group, domain: mg_a.domain, order: mg_a.order)
      mg_b.menu = menu
      expect(mg_b.valid?).to be_falsy
    end

    it 'unique order only applies to type' do
      menu_a = create(:menu)
      menu_b = create(:menu, domain: menu_a.domain)
      mg_a = create(:menu_group, domain: menu_a.domain)
      mg_a.menu = menu_a
      mg_b = create(:menu_group, domain: menu_b.domain, order: mg_a.order)
      mg_b.menu = menu_b
      expect(mg_b.valid?).to be_truthy
    end
  end

  context '.save' do
    it 'succeeds' do
      valid_group = build(:menu_group, text: "Valid Group")
      expect(valid_group.save).to be_truthy
    end

    it 'fails - no domain' do
      invalid_group = build(:menu_group, domain: Domain.new)
      expect(invalid_group.save).to be_falsy
    end

    it 'fails duplicate text {scoped => :menu}' do
      travel = create(:menu, text: 'Travel')
      fly = create(:menu_group, text: 'Fly Group', menu: travel)
      duplicate_text = build(:menu_group, text: 'Fly Group', menu: travel)
      expect(duplicate_text.save).to be_falsy
    end

    it 'allows duplicate text (separate menus)' do
      menu_a = create(:menu, text: "Code")
      menu_b = create(:menu, text: "Travel", domain: menu_a.domain)
      group = create(:menu_group, text: 'Test Group', menu: menu_a)
      duplicate_text = build(:menu_group, text: 'Test Group', menu: menu_b)
      expect(duplicate_text.save).to be_truthy
    end
  end
end
