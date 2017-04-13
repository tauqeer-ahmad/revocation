class CreateSectionSubjectTeachers < ActiveRecord::Migration[5.0]
  def change
    create_table :section_subject_teachers do |t|
      t.integer :section_id
      t.integer :subject_id
      t.integer :teacher_id
      t.integer :klass_id
      t.integer :term_id
      t.integer :institution_id

      t.timestamps
    end
  end
end
