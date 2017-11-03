class AddActualObtainedToExamMarks < ActiveRecord::Migration[5.0]
  def change
    add_column :exam_marks, :actual_obtained, :decimal, precision: 5, scale: 2
  end
end
