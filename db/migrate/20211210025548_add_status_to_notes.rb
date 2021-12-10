class AddStatusToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :in_private, :boolean, default: :false
  end
end
