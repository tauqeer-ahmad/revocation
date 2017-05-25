class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.references :attendee, polymorphic: true, index: true
      t.references :attendance_sheet, foreign_key: true, index: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
