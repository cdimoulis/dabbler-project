# == Schema Information
#
# Table name: menus
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  order       :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Menu, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:domain) }
    it { is_expected.to have_many(:menus_menu_groups) }
    it { is_expected.to have_many(:menu_groups).through(:menus_menu_groups) }
  end

  context '.save' do
    it 'succeeds' do
      menu = build(:menu)
      expect(menu.save).to be_truthy
    end
  end

  context 'validations' do
    it 'fails with duplicate text' do
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

    it 'fails with duplicate order' do
      menu_a = create(:menu)
      menu_b = build(:menu, order: menu_a.order, domain: menu_a.domain)
      expect(menu_b.valid?).to be_falsy
    end

    it 'allows duplicate order in different domain' do
      menu_a = create(:menu)
      menu_b = build(:menu, order: menu_a.order)
      expect(menu_b.valid?).to be_truthy
    end
  end
end
