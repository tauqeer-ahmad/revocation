class AddRegistrationNumberToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :registration_number, :string, limit: 20
  end
end
