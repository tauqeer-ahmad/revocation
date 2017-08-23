class AddStatusToAssignments < ActiveRecord::Migration[5.0]
  def change
    add_column :assignments, :status, :string
    add_index :assignments, :status
  end
end
