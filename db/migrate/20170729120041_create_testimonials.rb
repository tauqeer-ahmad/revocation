class CreateTestimonials < ActiveRecord::Migration[5.0]
  def change
    create_table :testimonials do |t|
      t.string :heading, null: false, limit: 100
      t.text :message
      t.string :status, limit: 20, default: 'inactive'
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
