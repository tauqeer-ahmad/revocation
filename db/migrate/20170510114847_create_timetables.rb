class CreateTimetables < ActiveRecord::Migration[5.0]
  def change
    create_table :timetables do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :day_of_week
      t.references(:term, index: true)
      t.references(:section, index: true)
      t.references(:subject, index: true)
      t.references(:klass, index: true)
      t.references(:teacher, index: true)

      t.timestamps
    end
  end
end
