class CreateSectionStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :section_students do |t|
      t.integer :section_id
      t.integer :student_id
      t.integer :term_id
      t.integer :klass_id
      t.string :roll_number, limit: 32

      t.timestamps
    end
  end
end
