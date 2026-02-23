require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.create_home_memo! unless @user.home_memo
    sign_in @user
  end
  test "should get index" do
    get root_path
    assert_response :success
  end
end
