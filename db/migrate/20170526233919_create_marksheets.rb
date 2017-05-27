class CreateMarksheets < ActiveRecord::Migration[5.0]
  def change
    create_table :marksheets do |t|
      t.references(:term, index: true)
      t.references(:subject, index: true)
      t.references(:klass, index: true)
      t.references(:exam, index: true)
      t.references(:section, index: true)

      t.timestamps
    end
    add_index :marksheets, [:term_id, :exam_id, :klass_id, :section_id, :subject_id], unique: true,  name: 'marksheet_combined_index'
  end
end
