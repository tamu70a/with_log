class CreateMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :memos do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.date :memo_date

      t.timestamps
    end
  end
end
