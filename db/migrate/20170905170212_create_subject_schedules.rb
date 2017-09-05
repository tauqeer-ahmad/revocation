class CreateSubjectSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :subject_schedules do |t|
      t.text :content
      t.references :teacher
      t.references :subject, foreign_key: true
      t.references :section, foreign_key: true
      t.references :klass, foreign_key: true
      t.references :term, foreign_key: true
      t.datetime   :deleted_at
      t.timestamps
    end

    add_index :subject_schedules, [:teacher_id, :term_id]
    add_index :subject_schedules, :deleted_at
  end
end
