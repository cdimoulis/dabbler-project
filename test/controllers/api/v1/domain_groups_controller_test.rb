require 'test_helper'

class Api::V1::DomainGroupsControllerTest < ActionController::TestCase

  def setup
    @travel = domains(:travel)
    @code = domains(:code)
    @fly = domain_groups(:fly)
    @hotel = domain_groups(:hotel)
    @web = domain_groups(:web)
    @unused = domain_groups(:unused)
    @create_a_params = {text: "Train", description: "Train group in travel", domain_id: @travel.id}
    @create_b_params = {text: "Microcontroller", description: "Microcontroller programming"}
    @bad_update_params = {subdomain: "Train"}
  end

  # Create route
  test "create" do
    # Assert that the DomainGroup count is increased by 1 after POST
    # Standard create route
    # puts "\n\nController PATH #{api_v1_domain_domain_groups_path(domain_id: @code.id)}\n\n"
    assert_difference('@travel.domain_groups.count', 1, "DomainGroup Controller Create: Creation failed.\n#{@response.body.inspect}") do
      post :create, domain_group: @create_a_params
    end
    assert_redirected_to api_v1_domain_group_path(assigns(:record)), "DomainGroups Controller Create 1: Redirect failed.\n#{@response.body.inspect}"

  end

  # Index route
  test "index" do
    # get :index, format: :json
    # assert_response :success
    # assert_not_nil assigns(:records)
  end
end
