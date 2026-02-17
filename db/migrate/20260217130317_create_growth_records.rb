class CreateGrowthRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :growth_records do |t|
      t.references :child, null: false, foreign_key: true
      t.integer :month_age
      t.float :body_height
      t.float :body_weight
      t.text :content

      t.timestamps
    end
  end
end
