class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.datetime :assigned_at
      t.datetime :submission_deadline
      t.string   :heading
      t.text     :task
      t.integer  :teacher_id, foreign_key: true, index: true
      t.references :section, foreign_key: true, index: true
      t.references :subject, foreign_key: true, index: true
      t.references :term, foreign_key: true, index: true

      t.timestamps
    end
  end
end
