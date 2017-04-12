class CreateSections < ActiveRecord::Migration[5.0]
  def change
    create_table :sections do |t|
      t.string :name
      t.string :nickname
      t.integer :term_id
      t.integer :klass_id
      t.integer :institution_id
      t.integer :incharge_id

      t.timestamps
    end
  end
end
