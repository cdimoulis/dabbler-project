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

RSpec.describe Group do

  context 'associations' do
    it { is_expected.to belong_to(:domain) }
    it { is_expected.to have_many(:topics) }
    it { expect(Group.reflect_on_association(:published_entries).macro).to eq(:has_many)}
    it { expect(Group.reflect_on_association(:published_entries).options[:through]).to eq(:group_topic_published_entries)}
    # Appears to be an error in the shoulda matchers for have_many.through
    # it { is_expected.to have_many(:published_entries).through(:group_topic_published_entries) }

    it 'accesses published_entries' do
      group = create(:group)
      published_entry_a = create(:published_entry, domain: group.domain)
      published_entry_b = create(:published_entry, domain: group.domain)
      published_entry_c = create(:published_entry, domain: group.domain)

      group.published_entries << published_entry_b
      group.published_entries << published_entry_c
      expect(group.published_entries).to match([published_entry_b, published_entry_c])
      join = GroupTopicPublishedEntry.where(group_id: group.id)
      expect(join.length).to eq(2)
    end
  end

  context '.save' do
    it 'succeeds' do
      valid_group = build(:group, text: "Valid Group")
      expect(valid_group.save).to be_truthy
    end

    it 'fails - no domain' do
      invalid_group = build(:group, domain: Domain.new)
      expect(invalid_group.save).to be_falsy
    end

    it 'fails duplicate text {scoped => :domain, :type}' do
      travel = create(:domain, text: 'Travel')
      fly = create(:group, text: 'Fly Group', domain: travel)
      duplicate_text = build(:group, text: 'Fly Group', domain: travel)
      expect(duplicate_text.save).to be_falsy
    end

    it 'allows duplicate text (separate type)' do
      travel = create(:domain, text: "Travel")
      group = create(:featured_group, text: 'Test Group', domain: travel)
      duplicate_text = build(:tutorial_group, text: 'Test Group', domain: travel)
      expect(duplicate_text.save).to be_truthy
    end

    it 'allows duplicate text (separate domain)' do
      code = create(:domain, text: "Code")
      travel = create(:domain, text: "Travel")
      group = create(:group, text: 'Test Group', domain: code)
      duplicate_text = build(:group, text: 'Test Group', domain: travel)
      expect(duplicate_text.save).to be_truthy
    end
  end
end
