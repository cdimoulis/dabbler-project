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

RSpec.describe FeaturedGroup do

  context 'inheritance' do
    it 'type is correct' do
      domain_group = create(:featured_group)
      expect(domain_group.type).to eq('FeaturedGroup')
    end
  end

  context 'validations' do
    it 'requires unique order' do
      fg_a = create(:featured_group)
      fg_b = build(:featured_group, domain: fg_a.domain, order: fg_a.order)
      expect(fg_b.valid?).to be_falsy
    end

    it 'unique order only applies to type' do
      fg_a = create(:featured_group)
      fg_b = create(:featured_group, domain: fg_a.domain)
      tg = build(:tutorial_group, domain: fg_a.domain, order: fg_a.order)
      expect(tg.valid?).to be_truthy
    end
  end

  context 'associations' do
    it 'accesses featured_entries' do
      group = create(:featured_group)
      featured_entry_a = create(:featured_entry, domain: group.domain)
      featured_entry_b = create(:featured_entry, domain: group.domain)
      featured_entry_c = create(:featured_entry, domain: group.domain)

      group.featured_entries << featured_entry_b
      group.featured_entries << featured_entry_c
      # Change order for sorting scope of featured entries
      expect(group.featured_entries).to match([featured_entry_c, featured_entry_b])
      join = GroupTopicPublishedEntry.where(group_id: group.id)
      expect(join.length).to eq(2)
    end
  end
end
