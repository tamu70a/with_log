# app/services/weather_service.rb
require "httparty"

class WeatherService
  include HTTParty
  base_uri "api.openweathermap.org"

  def self.fetch(city: "tokyo")
    api_key = Rails.application.credentials.dig(:open_weather, :api_key)

    get(
      "/data/2.5/weather",
      query: {
        q: "#{city},jp",
        appid: api_key,
        lang: "ja"
      }
    )
  end
end
