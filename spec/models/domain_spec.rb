# == Schema Information
#
# Table name: domains
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  subdomain   :string           not null
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "rails_helper"

RSpec.describe Domain do

  context 'associations' do
    it { is_expected.to have_many(:groups) }
    it { is_expected.to have_many(:topics) }
  end

  context '.save' do
    it 'succeeds' do
      valid_domain = build(:domain, text: "Valid")
      expect(valid_domain.save).to be_truthy
    end

    it 'fails duplicate text' do
      travel = create(:domain, text: 'Travel')
      duplicate_text = Domain.new(text: "Travel", description: "a duplicate travel", subdomain: "test")
      expect(duplicate_text.save).to be_falsy
    end

    it 'fails duplicate subdomain' do
      code = create(:domain, text: 'Code')
      duplicate_subdomain = Domain.new(text: "My Domain", description: "My own domain", subdomain: "code")
      expect(duplicate_subdomain.save).to be_falsy
    end
  end
end
