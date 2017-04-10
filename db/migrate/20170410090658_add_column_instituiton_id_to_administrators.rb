class AddColumnInstituitonIdToAdministrators < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :institution_id, :integer
  end
end
