class AddTermToAttendanceSheets < ActiveRecord::Migration[5.0]
  def change
    add_reference :attendance_sheets, :term, foreign_key: true, index: true
  end
end
