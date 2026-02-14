class CreateWeightGoals < ActiveRecord::Migration[7.2]
  def change
    create_table :weight_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.float :target_weight
      t.date :target_date

      t.timestamps
    end
  end
end
