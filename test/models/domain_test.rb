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

require 'test_helper'

class DomainTest < ActiveSupport::TestCase

  # Creationg of domain succeeds
  test "new_domain" do
    # Empty Domain
    empty_domain = Domain.new()
    assert_not empty_domain.save, "New Domain: Empty Domain saved"

    # Correct Domain: Active
    active_domain = Domain.new(text: "Test", description: "test domain", subdomain: "test")
    assert active_domain.save, "New Domain: Sufficient Domain would not save"
    assert active_domain.active, "New Domain: Active not default true"

    # Correct Domain: Inactive
    inactive_domain = Domain.new(text: "Test", description: "test domain", subdomain: "test", active: false)
    assert inactive_domain.save, "New Domain: Sufficient Domain would not save"
    assert_not inactive_domain.active, "New Domain: Inactive did not save properly"
  end

  # Responds
  test "domain_responds" do
    assert_respond_to domains(:travel), :domain_groups, "Domain Responds: Does not respond to domain_groups"
  end



end
