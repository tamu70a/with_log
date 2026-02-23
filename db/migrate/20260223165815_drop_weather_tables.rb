class DropWeatherTables < ActiveRecord::Migration[7.2]
  def change
    drop_table :weather_forecasts if table_exists?(:weather_forecasts)
    drop_table :weather_records if table_exists?(:weather_records)
  end
end
