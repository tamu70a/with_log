# app/controllers/homes_controller.rb
class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
     res = WeatherService.fetch(city: "tokyo")

  @weather = {
    description: res["weather"][0]["description"],
    temp: (res["main"]["temp"] - 273.15).round(1),
    humidity: res["main"]["humidity"]
  }
    @home_memo = current_user.home_memo || current_user.create_home_memo!
  end
end
