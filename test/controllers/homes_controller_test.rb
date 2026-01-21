require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.create_home_memo! unless @user.home_memo
    sign_in @user

    # 元の fetch を退避
    @original_fetch = WeatherService.method(:fetch)

    # fetch を差し替え（テスト用のダミーデータ）
    WeatherService.define_singleton_method(:fetch) do |city:|
      {
        "weather" => [
          { "description" => "晴れ" }
        ],
        "main" => {
          "temp" => 293.15,
          "humidity" => 40
        }
      }
    end
  end

  teardown do
    # fetch を元に戻す
    WeatherService.define_singleton_method(:fetch, @original_fetch)
  end

  test "should get index" do
    get root_path
    assert_response :success
  end
end
