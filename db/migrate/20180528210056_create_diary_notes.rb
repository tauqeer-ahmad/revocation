class CreateDiaryNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :diary_notes do |t|
      t.date :note_for
      t.string :heading
      t.text :note
      t.integer  :teacher_id, foreign_key: true, index: true
      t.integer  :student_id, foreign_key: true, index: true
      t.references :section, foreign_key: true
      t.references :subject, foreign_key: true
      t.references :term, foreign_key: true

      t.timestamps
    end
  end
end
