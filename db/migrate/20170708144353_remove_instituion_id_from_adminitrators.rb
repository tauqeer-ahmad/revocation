class RemoveInstituionIdFromAdminitrators < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :institution_id
  end
end
