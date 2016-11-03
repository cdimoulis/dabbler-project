require 'test_helper'

class DomainGroupsTest < ActionDispatch::IntegrationTest

  def setup
    @code = domains(:code)
    @create_params = {text: "Microcontroller", description: "Microcontroller programming"}
  end

  test "create" do
    # Assert that the Domain count is increased by 1 after POST
    # Via Domain route
    puts "\n\nIntegration PATH #{api_v1_domain_domain_groups_path(domain_id: @code.id)}\n\n"
    assert_difference('@code.domain_groups.count', 1, "DomainGroup Create: Creation failed.\n#{@response.body.inspect}") do
      post api_v1_domain_domain_groups_path(domain_id: @code.id), domain_group: @create_params
    end
    assert_redirected_to api_v1_domain_domain_group_path(@code, assigns(:record)), "DomainGroups Create 2: Redirect failed.\n#{@response.body.inspect}"
  end
end
