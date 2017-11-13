class UpdateExamMarksObtainedColumnDataType < ActiveRecord::Migration[5.0]
  def change
    change_column :exam_marks, :obtained, :decimal, precision: 5, scale: 2
  end
end
