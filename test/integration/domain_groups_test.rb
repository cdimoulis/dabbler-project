require 'test_helper'

class DomainGroupsTest < ActionDispatch::IntegrationTest

  def setup
    @code = domains(:code)
    @create_params = {text: "Microcontroller", description: "Microcontroller programming"}
  end

  test "create" do
    # Assert that the Domain count is increased by 1 after POST
    # Via Domain route
    create_path = api_v1_domain_domain_groups_path(domain_id: @code.id)
    puts "\n\nIntegration PATH #{create_path}\n\n"
    
    assert_difference('@code.domain_groups.count', 1, "DomainGroup Create: Creation failed.") do
      # post create_path, domain_group: @create_params
      post_via_redirect create_path, domain_group: @create_params, format: :json
    end
    puts "\n\nResponse: #{@response.inspect}\n\n"
    assert_response :success
    # assert_redirected_to api_v1_domain_domain_group_path(assigns(:record)), "DomainGroups Create 2: Redirect failed.\n#{@response.body.inspect}"
  end
end
