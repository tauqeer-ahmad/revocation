class AddSectionIdToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :enrollment_term_id, :integer
  end
end
