require 'test_helper'

class Api::V1::DomainsControllerTest < ActionController::TestCase

  def setup
    @travel = domains(:travel)
    @params = {text: "Create Test", description: "test create", subdomain: "create_test"}
  end

  test "create" do
    # Create without sending params
    post :create
    assert_response 422, "Domain Create: Empty post did not fail"

    # Create with params
    post :create, domain: @params
    assert_response :success, "Domain Create: Creation failed.\n#{@response.body.inspect}\n"

    puts "\n\npath: #{domain_path(assigns(:domain))}\n\n"
  end

end
