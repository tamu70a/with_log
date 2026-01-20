require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end
  test "should get index" do
    get homes_index_url
    assert_response :success
  end
end
