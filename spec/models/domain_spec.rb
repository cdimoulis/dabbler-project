require "rails_helper"
include FactoryGirl::Syntax::Methods

RSpec.describe Domain do

  context 'save new' do
    it 'is not empty' do
      empty_domain = Domain.new()
      expect(empty_domain.save).to be_falsey
    end

    it 'saves a correct domain' do
      valid_domain = build(:domain, text: "Valid")
      expect(valid_domain.save).to be_truthy
    end

    it 'will not save duplicate text' do
      travel = create(:domain, text: 'Travel')
      duplicate_text = Domain.new(text: "Travel", description: "a duplicate travel", subdomain: "test")
      expect(duplicate_text.save).to be_falsy
    end

    it 'will not save duplicate subdomain' do
      code = create(:domain, text: 'Code')
      duplicate_subdomain = Domain.new(text: "My Domain", description: "My own domain", subdomain: "code")
      expect(duplicate_subdomain.save).to be_falsy
    end
  end

  context 'associations' do
    it 'responds to :domain_groups' do
      travel = build(:domain)
      expect(travel.respond_to?(:domain_groups)).to be_truthy
    end
  end
end
