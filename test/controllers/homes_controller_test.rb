require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.create_home_memo! unless @user.home_memo
    sign_in @user  # Deviseのヘルパーメソッドを使用
  end

  test "should get index" do
    get homes_index_url
    assert_response :success
  end
end