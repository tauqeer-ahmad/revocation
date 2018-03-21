class CreateTeacherAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :teacher_attendances do |t|
      t.date :day
      t.string :status
      t.boolean :late
      t.integer :teacher_id, foreign_key: true, index: true
      t.references :term, foreign_key: true, index: true
      t.string :remarks
      t.datetime :arrival
      t.datetime :departure

      t.timestamps
    end
  end
end
