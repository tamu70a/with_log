class CreateBodyRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :body_records do |t|
      t.float :weight
      t.float :body_fat
      t.date :measured_on
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
