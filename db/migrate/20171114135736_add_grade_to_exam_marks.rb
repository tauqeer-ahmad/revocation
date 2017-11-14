class AddGradeToExamMarks < ActiveRecord::Migration[5.0]
  def change
    add_column :exam_marks, :grade, :string, limit: 10
  end
end
