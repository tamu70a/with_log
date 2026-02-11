class CreateHabitChecks < ActiveRecord::Migration[7.2]
  def change
    create_table :habit_checks do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :check_date

      t.timestamps
    end
  end
end
