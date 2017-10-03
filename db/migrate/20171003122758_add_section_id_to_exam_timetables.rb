class AddSectionIdToExamTimetables < ActiveRecord::Migration[5.0]
  def change
    add_reference :exam_timetables, :section, index: true
  end
end
