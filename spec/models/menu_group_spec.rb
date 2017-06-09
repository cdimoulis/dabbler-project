# == Schema Information
#
# Table name: menu_groups
#
#  id                       :uuid             not null, primary key
#  text                     :string           not null
#  description              :text
#  menu_id                  :uuid             not null
#  order                    :integer
#  topic_ordering           :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  published_entry_ordering :text             default(["\"published_at:desc\""]), is an Array
#  creator_id               :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'rails_helper'

RSpec.describe MenuGroup, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:menu) }
    it { is_expected.to belong_to(:creator).class_name('User') }
    it { is_expected.to have_many(:topics) }
    it { is_expected.to have_many(:menu_group_published_entry_topics) }
    it { expect(MenuGroup.reflect_on_association(:published_entries).macro).to eq(:has_many)}
    it { expect(MenuGroup.reflect_on_association(:published_entries).options[:through]).to eq(:menu_group_published_entry_topics)}

    it 'accesses menu' do
      menu = create(:menu)
      menu_group_a = create(:menu_group)
      menu_group_b = create(:menu_group)
      menu_group_a.menu = menu
      menu_group_a.save
      menu_group_b.menu = menu
      menu_group_b.save
      expect(menu.menu_groups.to_a).to match([menu_group_a, menu_group_b])
    end
  end

  context 'validations' do
    it 'requires unique order within menu' do
      mg_a = create(:menu_group)
      mg_b = build(:menu_group, menu: mg_a.menu, order: mg_a.order)
      expect(mg_b.valid?).to be_falsy
    end

    it 'unique order only applies to menu' do
      menu_a = create(:menu)
      menu_b = create(:menu, domain: menu_a.domain)
      mg_a = create(:menu_group)
      mg_a.menu = menu_a
      mg_b = create(:menu_group, order: mg_a.order)
      mg_b.menu = menu_b
      expect(mg_b.valid?).to be_truthy
    end

    it 'fails - no menu' do
      invalid_group = build(:menu_group, menu: Menu.new)
      expect(invalid_group.valid?).to be_falsy
    end

    it 'fails duplicate text {scoped => :menu}' do
      travel = create(:menu, text: 'Travel')
      fly = create(:menu_group, text: 'Fly Group', menu: travel)
      duplicate_text = build(:menu_group, text: 'Fly Group', menu: travel)
      expect(duplicate_text.valid?).to be_falsy
    end

    it 'allows duplicate text (separate menus)' do
      menu_a = create(:menu, text: "Code")
      menu_b = create(:menu, text: "Travel", domain: menu_a.domain)
      group = create(:menu_group, text: 'Test Group', menu: menu_a)
      duplicate_text = build(:menu_group, text: 'Test Group', menu: menu_b)
      expect(duplicate_text.valid?).to be_truthy
    end

    context 'ordering' do
      it 'fails invalid menu_group_ordering' do
        menu_group = build(:menu_group, topic_ordering: ['text', 'order', 'oreo'])
        expect(menu_group.valid?).to be_falsy
      end

      it 'fails invalid published_entry_ordering' do
        menu_group = build(:menu_group, published_entry_ordering: ['text', 'order', 'oreo'])
        expect(menu_group.valid?).to be_falsy
      end

      it 'allows published_entry_ordering parents' do
        menu_group = build(:menu_group, published_entry_ordering: ['Topic'])
        expect(menu_group.valid?).to be_truthy
      end
    end
  end

  context '.save' do
    it 'succeeds' do
      valid_group = build(:menu_group, text: "Valid Group")
      expect(valid_group.save).to be_truthy
    end
  end

  context 'scope' do
    context 'ordering concern' do
      let!(:a) { create(:menu_group, text: 'A', order: nil) }
      let!(:b) { create(:menu_group, text: 'B', order: nil) }
      let!(:c) { create(:menu_group, text: 'C', order: 3) }
      let!(:d) { create(:menu_group, text: 'D', order: 2) }
      let!(:e) { create(:menu_group, text: 'E', order: 1) }
      let!(:f) { create(:menu_group, text: 'F', order: nil) }
      let!(:menu) { create(:menu) }

      it 'orders with domain default ordering' do
        ordered = [e,d,c,a,b,f]
        expect(MenuGroup.ordering_scope(menu).to_a).to match(ordered)
      end

      it 'orders with menu reverse ordering' do
        menu.update_attribute(:menu_group_ordering, ['order:desc','text:desc'])
        ordered = [c,d,e,f,b,a]
        expect(MenuGroup.ordering_scope(menu).to_a).to match(ordered)
      end

      it 'orders correctly with text first' do
        menu.update_attribute(:menu_group_ordering, ['text:asc','order:asc'])
        f.update_attribute(:order, 4)
        b.update_attribute(:order, 5)
        a.update_attribute(:order, 6)
        ordered = [a,b,c,d,e,f]
        expect(MenuGroup.ordering_scope(menu).to_a).to match(ordered)
      end

      it 'orders correctly with all order' do
        f.update_attribute(:order, 4)
        b.update_attribute(:order, 5)
        a.update_attribute(:order, 6)
        ordered = [e,d,c,f,b,a]
        expect(MenuGroup.ordering_scope(menu).to_a).to match(ordered)
      end

      it 'orders correctly with no order' do
        c.update_attribute(:order, nil)
        d.update_attribute(:order, nil)
        e.update_attribute(:order, nil)
        ordered = [a,b,c,d,e,f]
        expect(MenuGroup.ordering_scope(menu).to_a).to match(ordered)
      end
    end
  end
end
