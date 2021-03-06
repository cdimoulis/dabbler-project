require 'test_helper'

class Blog::V1::DomainsControllerTest < ActionController::TestCase

  def setup
    @travel = domains(:travel)
    @code = domains(:code)
    @unused = domains(:unused)
    @create_params = {text: "Create Test", description: "test create", subdomain: "create_test"}
    @bad_update_params = {subdomain: "travel"}
    @update_params = {description: "Travel related entries"}
  end

  # Create route
  test "create" do
    # Create without sending params
    post :create
    assert_response 422, "Domain Controller Create: Empty post did not fail"

    # Assert that the Domain count is increased by 1 after POST
    assert_difference('Domain.count', 1, "Domain Controller Create: Creation failed.\n#{@response.body.inspect}") do
      post :create, domain: @create_params
    end

    assert_redirected_to blog_v1_domain_path(assigns(:record)), "Domain Controller Create: Redirect failed.\n#{@response.body.inspect}"
  end

  # Index route
  test "index" do
    get :index, format: :json
    assert_response :success, "Domains Controller: index request not success."
    assert_not_nil assigns(:records), "Domains Controller: index records nil."
  end

  # Show route
  test "show" do
    get :show, id: @travel, format: :json
    assert_response :success, "Domain Controller Show: Response NOT successful"
    assert_equal @travel.id, assigns(:record).id, "Domain Show: Return incorrect record"
  end

  # Update route
  test "update" do
    # Proper update
    put :update, id: @travel, domain: @update_params, headers: @headers
    @travel = assigns(:record)
    assert_equal @update_params[:description], @travel.description, "Domain Controller Update: Update failed"

    # Invalid update
    put :update, id: @code, domain: @bad_update_params
    assert_response 424, "Domain Controller Update: Invalid update did not error\n#{@response.body.inspect}"
  end

  # Destroy route
  # test "destroy" do
  #   assert_difference('Domain.count', -1, "Domain Delete: failure") do
  #     delete :destroy, id: @unused
  #   end
  #
  #   assert_redirected_to blog_v1_domain_path
  # end



  ###
  # Currently not used Routes. Ensure they are not reachable
  ###
  # test "new" do
  #   get :new, id: @code
  #   assert_response :missing, "Domain New: route not missing"
  # end
  #
  # test "edit" do
  #   get :edit, id: @code
  #   assert_response :missing, "Domain Edit: route not missing"
  # end

end
