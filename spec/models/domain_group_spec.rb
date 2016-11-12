require "rails_helper"
include FactoryGirl::Syntax::Methods

RSpec.describe DomainGroup do

context 'associations' do
  it { is_expected.to belong_to(:domain) }
end

  context '.new' do
    it 'cannot be emtpy' do
      empty_domain_group = DomainGroup.new()
      expect(empty_domain_group.save).to be_falsy
    end
  end

  context '.save' do
    it 'succeeds' do
      valid_group = build(:domain_group, text: "Valid Group")
      expect(valid_group.save).to be_truthy
    end

    it 'fails without domain' do
      invalid_group = build(:domain_group, domain: Domain.new)
      expect(invalid_group.save).to be_falsy
    end

    it 'fails duplicate text {scoped => :domain}' do
      travel = create(:domain, text: 'Travel')
      fly = create(:domain_group, text: 'Fly Group', domain: travel)
      duplicate_text = build(:domain_group, text: 'Fly Group', domain: travel)
      expect(duplicate_text.save).to be_falsy
    end

    it 'allows duplicate text (separate domain)' do
      code = create(:domain, text: "Code")
      travel = create(:domain, text: "Travel")
      group = create(:domain_group, text: 'Test Group', domain: code)
      duplicate_text = build(:domain_group, text: 'Test Group', domain: travel)
      expect(duplicate_text.save).to be_truthy
    end
  end
end
