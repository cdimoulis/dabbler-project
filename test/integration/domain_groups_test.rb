require 'test_helper'

class DomainGroupsTest < ActionDispatch::IntegrationTest

  def setup
    @code = domains(:code)
    @create_params = {text: "Microcontroller", description: "Microcontroller programming"}
  end

  test "create" do
    # Check creating DomainGroup with Domain in path
    create_path = api_v1_domain_domain_groups_path(domain_id: @code.id)

    assert_difference('@code.domain_groups.count', 1, "DomainGroup Create: Creation failed.") do
      post_via_redirect create_path, domain_group: @create_params, format: :json
    end
    assert_response :success
  end
end
