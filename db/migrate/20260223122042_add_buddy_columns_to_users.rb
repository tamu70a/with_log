class AddBuddyColumnsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :buddy_memo, :text
    add_column :users, :last_buddy_updated_at, :datetime
  end
end
