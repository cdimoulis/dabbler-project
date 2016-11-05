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
    @update_params = {description: "Do not use anymore"}
    @bad_update_params = {text: "Fly"}
  end

  # Create route
  test "create" do
    # Assert that the DomainGroup count is increased by 1 after POST
    # Standard create route
    assert_difference('@travel.domain_groups.count', 1, "DomainGroup Controller Create: Creation failed.\n#{@response.body.inspect}") do
      post :create, domain_group: @create_a_params
    end
    assert_redirected_to api_v1_domain_group_path(assigns(:record)), "DomainGroups Controller Create 1: Redirect failed.\n#{@response.body.inspect}"

  end

  # Index route
  test "index" do
    get :index, format: :json
    assert_response :success, "DomainGroups Controller: index request not success."
    assert_not_nil assigns(:records), "DomainGroups Controller: index records nil."
  end

  # Show route
  test "show" do
    get :show, id: @fly, format: :json
    assert_response :success, "DomainGroups Controller Show: Response NOT successful"
    assert_equal @fly.id, assigns(:record).id, "DomainGroups Show: Return incorrect record"
  end

  # Update route
  test "update" do
    update_path = api_v1_domain_group_path(@unused)
    # Proper update
    put :update, id: @unused, domain_group: @update_params, headers: @headers
    assert_redirected_to update_path, "DomainGroup Controller Update: Did not redirect properly: #{update_path}\n#{@response.body.inspect}"
    assert_equal @update_params[:description], assigns(:record).description, "Domain Controller Update: Update failed\n#{@response.body.inspect}"

    # Invalid update
    put :update, id: @hotel, domain_group: @bad_update_params
    assert_response 424, "DomainGroup Controller Update: Invalid update did not error\n#{assigns(:record).errors.inspect}"

    # Duplicate text different domains
    put :update, id: @unused, domain_group: @bad_update_params
    assert_redirected_to update_path, "DomainGroup Controller Update: Did not redirect properly: #{update_path}\n#{@response.body.inspect}"
  end

  # Destroy route
  test "destroy" do
    assert_difference('DomainGroup.count', -1, "DomainGroup Destroy: Did not properly destroy #{@response.body.inspect}") do
      delete :destroy, id: @unused, format: :json
    end
    assert_response :success, "DomainGroup Destroy: Response was not success\n#{@response.status}\n#{@response.body.inspect}"
  end
end
