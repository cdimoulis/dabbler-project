require 'test_helper'

class Api::V1::DomainsControllerTest < ActionController::TestCase

  def setup
    @travel = domains(:travel)
    @params = {text: ""}
  end

  test "create" do
    # Create without sending params
    post :create
    assert_response 422, "Domain Create: Empty post did not fail"


  end

end
