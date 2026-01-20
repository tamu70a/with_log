class RenameHomeNotesToHomeMemos < ActiveRecord::Migration[7.2]
  def change
    rename_table :home_notes, :home_memos
  end
end
