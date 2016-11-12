require "rails_helper"
include FactoryGirl::Syntax::Methods

RSpec.describe Domain do

  context 'associations' do
    it { is_expected.to have_many(:domain_groups) }
  end

  context '.new' do
    it 'cannot be empty' do
      empty_domain = Domain.new()
      expect(empty_domain.save).to be_falsey
    end
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
