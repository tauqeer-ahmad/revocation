class AddAtrributesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :type_of, :string
    add_column :users, :first_name, :string, limit: 50
    add_column :users, :last_name, :string, limit: 50
    add_column :users, :address, :string
    add_column :users, :role, :string, limit: 12
    add_column :users, :roll_number, :string, limit: 12
    add_column :users, :qualification, :string
  end
end
