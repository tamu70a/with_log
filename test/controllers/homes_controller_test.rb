require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)

    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "password"
      }
    }
  end

  test "should get index" do
    get root_url
    assert_response :success
  end
end
