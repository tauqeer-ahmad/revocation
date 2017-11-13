class CreateGradingSystems < ActiveRecord::Migration[5.0]
  def change
    create_table :grading_systems do |t|
      t.string :name
      t.text :description
      t.integer :position, null: false, index: true

      t.timestamps
    end
  end
end
