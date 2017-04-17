class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mobile, :string, limit: 25
    add_column :users, :phone, :string, limit: 25
    add_column :users, :dob, :date
    add_column :users, :gender, :string, limit: 7
  end
end
