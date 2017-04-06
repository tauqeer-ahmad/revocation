class CreateInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :institutions do |t|
      t.string :name
      t.text :location
      t.integer :latitude
      t.integer :longitude
      t.string :city, limit: 20
      t.string :country, limit: 20
      t.text :description
      t.string :sector, limit: 20
      t.string :level, limit: 20
      t.string :status, limit: 12

      t.timestamps
    end
  end
end
