# == Schema Information
#
# Table name: groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  id   :uuid             not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "rails_helper"

RSpec.describe Group do

  context 'associations' do
    it { is_expected.to belong_to(:domain) }
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

    it 'fails duplicate text {scoped => :domain}' do
      travel = create(:domain, text: 'Travel')
      fly = create(:group, text: 'Fly Group', domain: travel)
      duplicate_text = build(:group, text: 'Fly Group', domain: travel)
      expect(duplicate_text.save).to be_falsy
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
