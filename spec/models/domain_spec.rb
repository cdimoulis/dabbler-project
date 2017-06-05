# == Schema Information
#
# Table name: domains
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  subdomain   :string           not null
#  active      :boolean          default(TRUE)
#  creator_id  :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "rails_helper"

RSpec.describe Domain do

  context 'associations' do
    it { is_expected.to have_many(:menu_groups) }
    it { is_expected.to have_many(:topics) }
    it { is_expected.to have_many(:published_entries) }
    it { is_expected.to have_many(:featured_entries) }
    it { is_expected.to have_many(:menus) }
    it { is_expected.to belong_to(:creator).class_name('User') }
  end

  context 'validations' do
    it 'fails duplicate text' do
      travel = create(:domain, text: 'Travel')
      duplicate_text = Domain.new(text: "Travel", description: "a duplicate travel", subdomain: "test")
      expect(duplicate_text.valid?).to be_falsy
    end

    it 'fails duplicate subdomain' do
      code = create(:domain, text: 'Code')
      duplicate_subdomain = Domain.new(text: "My Domain", description: "My own domain", subdomain: "code")
      expect(duplicate_subdomain.valid?).to be_falsy
    end

    it 'allows duplicate text if active: false' do
      travel = create(:domain, text: 'Travel', active: false)
      duplicate_text = Domain.new(text: "Travel", description: "a duplicate travel", subdomain: "test", active: false)
      expect(duplicate_text.valid?).to be_truthy
    end

    it 'allows duplicate subdomain if active: false' do
      code = create(:domain, text: 'Code', active: false)
      duplicate_subdomain = Domain.new(text: "My Domain", description: "My own domain", subdomain: "code", active: false)
      expect(duplicate_subdomain.valid?).to be_truthy
    end

    it 'allows duplicate text if one is active: false' do
      travel = create(:domain, text: 'Travel', active: false)
      duplicate_text = Domain.new(text: "Travel", description: "a duplicate travel", subdomain: "test")
      expect(duplicate_text.valid?).to be_truthy
    end

    it 'allows duplicate subdomain if one is active: false' do
      code = create(:domain, text: 'Code', active: false)
      duplicate_subdomain = Domain.new(text: "My Domain", description: "My own domain", subdomain: "code")
      expect(duplicate_subdomain.valid?).to be_truthy
    end
  end

  context '.save' do
    it 'succeeds' do
      valid_domain = build(:domain, text: "Valid")
      expect(valid_domain.save).to be_truthy
    end
  end
end
