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

require 'test_helper'

class DomainTest < ActiveSupport::TestCase

  # Creationg of domain succeeds
  test "save_new" do
    # Empty Domain
    empty_domain = Domain.new()
    assert_not empty_domain.save, "New Domain: Empty Domain saved"

    # Correct Domain: Active
    active_domain = Domain.new(text: "Model Test", description: "test domain", subdomain: "model_test")
    assert active_domain.save, "New Domain: Sufficient Domain would not save"
    assert active_domain.active, "New Domain: Active not default true"

    # Correct Domain: Inactive
    inactive_domain = Domain.new(text: "Model Test2", description: "test domain", subdomain: "model_test2", active: false)
    assert inactive_domain.save, "New Domain: Sufficient Domain would not save"
    assert_not inactive_domain.active, "New Domain: Inactive did not save properly"

    # Duplicate text Domain
    duplicate_text = Domain.new(text: "Model Test", description: "domain for testing", subdomain: "model_tests")
    assert_not duplicate_text.save, "New Domain: Duplicate text saved"

    # Duplicate subdomain Domain
    duplicate_subdomain = Domain.new(text: "My Domain", description: "My own domain", subdomain: "model_test")
    assert_not duplicate_subdomain.save, "New Domain: Duplicate subdomain saved"
  end

  # Responds to appropriate associations
  test "responds" do
    assert_respond_to domains(:travel), :domain_groups, "Domain Responds: Does not respond to domain_groups"
  end



end
