# == Schema Information
#
# Table name: menus
#
#  id                  :uuid             not null, primary key
#  text                :string           not null
#  description         :text
#  domain_id           :uuid             not null
#  order               :integer
#  menu_group_ordering :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  creator_id          :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Menu, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:domain) }
    it { is_expected.to belong_to(:creator).class_name('User') }
    it { is_expected.to have_many(:menu_groups) }
    it { is_expected.to have_many(:topics).through(:menu_groups) }
  end

  context '.save' do
    it 'succeeds' do
      menu = build(:menu)
      expect(menu.save).to be_truthy
    end
  end

  context 'validations' do
    it 'fails with duplicate text in same domain' do
      menu_a = create(:menu, text: 'Reviews')
      menu_b = build(:menu, text: 'Reviews', domain: menu_a.domain)
      expect(menu_b.valid?).to be_falsy
    end

    it 'allows duplicate text in different domain' do
      menu_a = create(:menu, text: 'Reviews')
      menu_b = build(:menu, text: 'Reviews')
      expect(menu_b.valid?).to be_truthy
    end

    it 'requires a domain' do
      menu = build(:menu, domain: nil)
      expect(menu.valid?).to be_falsy
    end

    it 'fails with duplicate order in same domain' do
      menu_a = create(:menu)
      menu_b = build(:menu, order: menu_a.order, domain: menu_a.domain)
      expect(menu_b.valid?).to be_falsy
    end

    it 'allows duplicate order in different domain' do
      menu_a = create(:menu)
      menu_b = build(:menu, order: menu_a.order)
      expect(menu_b.valid?).to be_truthy
    end

    context 'ordering' do
      it 'fails invalid menu_group_ordering' do
        menu = build(:menu, menu_group_ordering: ['text', 'order', 'oreo'])
        expect(menu.valid?).to be_falsy
      end
    end
  end

  context 'scope' do
    context 'ordering concern' do
      let!(:a) { create(:menu, domain: domain, text: 'A', order: nil) }
      let!(:b) { create(:menu, domain: domain, text: 'B', order: nil) }
      let!(:c) { create(:menu, domain: domain, text: 'C', order: 3) }
      let!(:d) { create(:menu, domain: domain, text: 'D', order: 2) }
      let!(:e) { create(:menu, domain: domain, text: 'E', order: 1) }
      let!(:f) { create(:menu, domain: domain, text: 'F', order: nil) }
      let!(:domain) { create(:domain) }

      it 'orders with domain default ordering' do
        ordered = [e,d,c,a,b,f]
        expect(Menu.ordering_scope(domain).to_a).to match(ordered)
      end

      it 'orders with domain reverse ordering' do
        domain.update_attribute(:menu_ordering, ['order:desc','text:desc'])
        ordered = [c,d,e,f,b,a]
        expect(Menu.ordering_scope(domain).to_a).to match(ordered)
      end

      it 'orders correctly with text first' do
        domain.update_attribute(:menu_ordering, ['text:asc','order:asc'])
        f.update_attribute(:order, 4)
        b.update_attribute(:order, 5)
        a.update_attribute(:order, 6)
        ordered = [a,b,c,d,e,f]
        expect(Menu.ordering_scope(domain).to_a).to match(ordered)
      end

      it 'orders correctly with all order' do
        f.update_attribute(:order, 4)
        b.update_attribute(:order, 5)
        a.update_attribute(:order, 6)
        ordered = [e,d,c,f,b,a]
        expect(Menu.ordering_scope(domain).to_a).to match(ordered)
      end

      it 'orders correctly with no order' do
        c.update_attribute(:order, nil)
        d.update_attribute(:order, nil)
        e.update_attribute(:order, nil)
        ordered = [a,b,c,d,e,f]
        expect(Menu.ordering_scope(domain).to_a).to match(ordered)
      end
    end
  end
end
