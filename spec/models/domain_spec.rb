require "rails_helper"
include FactoryGirl::Syntax::Methods

RSpec.describe Domain do

  context 'save new' do
    it 'does not allow empty domain' do
      empty_domain = Domain.new()
      expect(empty_domain.save).to be_falsey
    end

    it 'saves a correct domain' do
      active_domain = Domain.new(text: "Model Test", description: "test domain", subdomain: "model_test")
      expect(active_domain.save).to be_truthy
    end

    it 'does not allow duplicate text' do
      travel = create(:domain_travel)
      duplicate_text = Domain.new(text: "Travel", description: "a duplicate travel", subdomain: "test")
      expect(duplicate_text.save).to be_falsy
    end

    it 'does not allow duplicate subdomain' do
      code = create(:domain_code)
      duplicate_subdomain = Domain.new(text: "My Domain", description: "My own domain", subdomain: "code")
      expect(duplicate_subdomain.save).to be_falsy
    end
  end

  context 'associations' do
    it 'responds to :domain_groups' do
      travel = build(:domain_travel)
      expect(travel.respond_to?(:domain_groups)).to be_truthy
    end
  end
end
