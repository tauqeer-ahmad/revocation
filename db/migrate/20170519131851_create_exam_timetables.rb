class CreateExamTimetables < ActiveRecord::Migration[5.0]
  def change
    create_table :exam_timetables do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.date :paper_date
      t.references(:term, index: true)
      t.references(:subject, index: true)
      t.references(:klass, index: true)
      t.references(:exam, index: true)

      t.timestamps
    end
  end
end
