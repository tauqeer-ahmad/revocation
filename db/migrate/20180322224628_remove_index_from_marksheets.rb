class RemoveIndexFromMarksheets < ActiveRecord::Migration[5.0]
  def change
    remove_index :marksheets, [:term_id, :exam_id, :klass_id, :section_id, :subject_id]
  end
end
