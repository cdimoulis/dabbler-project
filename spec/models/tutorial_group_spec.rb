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

require "rails_helper"

RSpec.describe TutorialGroup do

  context 'inheritance' do
    it 'type is correct' do
      domain_group = create(:tutorial_group)
      expect(domain_group.type).to eq('TutorialGroup')
    end
  end

  context 'validations' do
    it 'requires unique order' do
      tg_a = create(:tutorial_group)
      tg_b = build(:tutorial_group, domain: tg_a.domain, order: tg_a.order)
      expect(tg_b.valid?).to be_falsy
    end

    it 'unique order only applies to type' do
      tg_a = create(:tutorial_group)
      tg_b = create(:tutorial_group, domain: tg_a.domain)
      fg = build(:featured_group, domain: tg_a.domain, order: tg_a.order)
      expect(fg.valid?).to be_truthy
    end
  end

  context 'associations' do
    it 'accesses tutorial_entries' do
      group = create(:tutorial_group)
      tutorial_entry_a = create(:tutorial_entry, domain: group.domain)
      tutorial_entry_b = create(:tutorial_entry, domain: group.domain)
      tutorial_entry_c = create(:tutorial_entry, domain: group.domain)

      group.tutorial_entries << tutorial_entry_b
      group.tutorial_entries << tutorial_entry_c
      # Change order for sorting scope of tutorial entries
      expect(group.tutorial_entries).to match([tutorial_entry_b, tutorial_entry_c])
      join = GroupTopicPublishedEntry.where(group_id: group.id)
      expect(join.length).to eq(2)
    end
  end
end
