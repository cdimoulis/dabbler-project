# == Schema Information
#
# Table name: groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
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
