class CreateExamMarks < ActiveRecord::Migration[5.0]
  def change
    create_table :exam_marks do |t|
      t.integer :obtained
      t.integer :total
      t.integer :passing_marks
      t.text :comment
      t.references(:term, index: true)
      t.references(:subject, index: true)
      t.references(:klass, index: true)
      t.references(:exam, index: true)
      t.references(:section, index: true)
      t.references(:student, index: true)
      t.references(:marksheet, index: true)

      t.timestamps
    end
  end
end
