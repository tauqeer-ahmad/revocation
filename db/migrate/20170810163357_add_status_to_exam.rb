class AddStatusToExam < ActiveRecord::Migration[5.0]
  def change
    add_column :exams, :status, :string, limit: 16, index: true
  end
end
