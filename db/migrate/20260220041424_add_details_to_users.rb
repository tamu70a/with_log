class AddDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :nickname, :string
    add_column :users, :childcare_mode, :boolean, default: false
  end
end
