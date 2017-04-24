class AddGuardianIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :guardian_id, :integer
    add_index :users, :guardian_id
  end
  
end
