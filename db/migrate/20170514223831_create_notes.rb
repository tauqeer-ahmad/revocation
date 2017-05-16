class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.string :heading, null: false, limit: 100
      t.text :description
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
