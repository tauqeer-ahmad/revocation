class CreateAttendanceSheets < ActiveRecord::Migration[5.0]
  def change
    create_table :attendance_sheets do |t|
      t.date :name
      t.integer :section_id, index: true
      t.integer :entity, default: 0
      t.integer :present
      t.integer :absent
      t.integer :leave

      t.timestamps
    end
  end
end
