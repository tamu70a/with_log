require "test_helper"

class HabitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get habits_url
    assert_response :success
  end
end
