class CreateGrades < ActiveRecord::Migration[5.0]
  def change
    create_table :grades do |t|
      t.string :name
      t.float :start_point
      t.float :end_point
      t.integer :points
      t.integer :position, null: false, index: true
      t.references :grading_system, foreign_key: true

      t.timestamps
    end
  end
end
