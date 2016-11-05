require 'test_helper'

class DomainGroupsTest < ActionDispatch::IntegrationTest

  def setup
    @code = domains(:code)
    @create_params = {text: "Microcontroller", description: "Microcontroller programming"}
  end

  test "create" do
    # Check creating DomainGroup with Domain in path
    create_path = api_v1_domain_domain_groups_path(domain_id: @code.id)

    assert_difference('@code.domain_groups.count', 1, "DomainGroup Integration Create: Creation failed.") do
      post_via_redirect create_path, domain_group: @create_params, format: :json
    end
    assert_response :success, "DomainGroup Integration Create: Response not success"
  end

  test "index" do
    # Check that the index route with Domain in path returns proper number of results
    get_path = api_v1_domain_domain_groups_path(domain_id: @code.id)

    get get_path, format: :json
    assert_response :success, "DomainGroups Integration Index: Response not success\n#{@response.status}\n#{@response.body.inspect}\n\n"

    assert_equal @code.domain_groups.count, assigns(:records).count, "DomainGroups Integration Index: Returned records do not equal actual"
  end
end
