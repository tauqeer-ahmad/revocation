class AddCnicAndProfessionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :cnic, :string, limit: 16
    add_column :users, :profession, :string, limit: 60
  end
end
