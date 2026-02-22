class CreateWeatherRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :weather_records do |t|
      t.float :temperature
      t.integer :humidity
      t.string :icon
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
