class AddPercentageToExams < ActiveRecord::Migration[5.0]
  def change
    add_column :exams, :percentage, :float
  end
end
