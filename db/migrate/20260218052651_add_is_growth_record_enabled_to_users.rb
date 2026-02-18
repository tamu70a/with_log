class AddIsGrowthRecordEnabledToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :is_growth_record_enabled, :boolean, default: true, null: false
  end
end
