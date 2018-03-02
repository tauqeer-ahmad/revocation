class CreateStudentAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :student_attendances do |t|
      t.date :day
      t.string :status, limit: '8'
      t.boolean :late
      t.integer :student_id
      t.integer :klass_id
      t.integer :section_id
      t.integer :term_id
      t.string :remarks
      t.boolean :send_sms

      t.timestamps
    end
  end
end
