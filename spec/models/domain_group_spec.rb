require "rails_helper"
include FactoryGirl::Syntax::Methods

RSpec.describe DomainGroup do

  context 'save new' do
    it 'is not emtpy' do
      empty_domain_group = DomainGroup.new()
      expect(empty_domain_group.save).to be_falsy
    end

    it 'saves a correct domain group' do
      valid_group = build(:domain_group, text: "Valid Group")
      expect(valid_group.save).to be_truthy
    end

    it 'save group with nil domain' do
      invalid_group = build(:domain_group, domain: Domain.new)
      expect(invalid_group.save).to be_falsy
    end

    it 'does not allow duplicate group text within domain' do
      travel = create(:domain, text: 'Travel')
      fly = create(:domain_group, text: 'Fly Group', domain: travel)
      duplicate_text = build(:domain_group, text: 'Fly Group', domain: travel)
      expect(duplicate_text.save).to be_falsy
    end

    it 'allows duplicate group text in different domains' do
      code = create(:domain, text: "Code")
      travel = create(:domain, text: "Travel")
      group = create(:domain_group, text: 'Test Group', domain: code)
      duplicate_text = build(:domain_group, text: 'Test Group', domain: travel)
      expect(duplicate_text.save).to be_truthy
    end
  end

  context 'associations' do
    it 'responds to :domain_groups' do
      group = build(:domain_group)
      expect(group.respond_to?(:domain)).to be_truthy
    end
  end
end
