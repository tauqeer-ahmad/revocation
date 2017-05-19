class CreateExams < ActiveRecord::Migration[5.0]
  def change
    create_table :exams do |t|
      t.string :name
      t.date :start_date
      t.text :comment
      t.references(:term, index: true)

      t.timestamps
    end
  end
end
