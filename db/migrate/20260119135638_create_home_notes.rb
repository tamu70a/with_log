class CreateHomeNotes < ActiveRecord::Migration[7.2]
  def change
    create_table :home_notes do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
