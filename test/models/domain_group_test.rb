# == Schema Information
#
# Table name: domain_groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class DomainGroupTest < ActiveSupport::TestCase

  # Creationg of domain_group succeeds
  test "save_new" do
    # Empty DomainGroup
    empty_group = DomainGroup.new()
    assert_not empty_group.save, "New DomainGroup: Empty DomainGroup saved"

    # No domain_id Domaing Group
    invalid_group = DomainGroup.new(text: "Test Group", description: "test group", domain_id: "abc")
    assert_not invalid_group.save, "New DomainGroup: Saved without valid Domain"

    # Accurate Domain DomainGroup
    travel = domains(:travel)
    dg = DomainGroup.new(text: "Test Group", description: "test domain", domain_id: travel.id)
    assert dg.save, "New DomainGroup: Sufficient Domain would not save"

    # Duplicate text, different domain
    code = domains(:code)
    dg = DomainGroup.new(text: "Test Group", description: "test domain", domain_id: code.id)
    assert dg.save, "New DomainGroup: Test, but different domain, will not save"

    # Duplicate text and domain
    dg = DomainGroup.new(text: "Test Group", description: "test domain", domain_id: travel.id)
    assert_not dg.save, "New DomainGroup: Duplicate text and domain saves"
  end

  # Responds to appropriate associations
  test "responds" do
    dg = DomainGroup.new
    assert_respond_to dg, :domain, "DomainGroup Responds: Does not respond to domain"
  end

end
