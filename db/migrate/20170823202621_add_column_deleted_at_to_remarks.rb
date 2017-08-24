class AddColumnDeletedAtToRemarks < ActiveRecord::Migration[5.0]
  def change
    add_column :terms, :deleted_at, :datetime
    add_column :exams, :deleted_at, :datetime
    add_column :exam_timetables, :deleted_at, :datetime

    add_column :sections, :deleted_at, :datetime
    add_column :timetables, :deleted_at, :datetime
    add_column :marksheets, :deleted_at, :datetime
    add_column :exam_marks, :deleted_at, :datetime
    add_column :attendance_sheets, :deleted_at, :datetime
    add_column :attendances, :deleted_at, :datetime
    add_column :assignments, :deleted_at, :datetime
    add_column :question_papers, :deleted_at, :datetime

    add_column :klasses, :deleted_at, :datetime
    add_column :subjects, :deleted_at, :datetime
    add_column :users, :deleted_at, :datetime
    add_column :remarks, :deleted_at, :datetime

    add_index :terms, :deleted_at
    add_index :exams, :deleted_at
    add_index :exam_timetables, :deleted_at

    add_index :sections, :deleted_at
    add_index :timetables, :deleted_at
    add_index :marksheets, :deleted_at
    add_index :exam_marks, :deleted_at
    add_index :attendance_sheets, :deleted_at
    add_index :attendances, :deleted_at
    add_index :assignments, :deleted_at
    add_index :question_papers, :deleted_at

    add_index :klasses, :deleted_at
    add_index :users, :deleted_at
    add_index :remarks, :deleted_at
  end
end
