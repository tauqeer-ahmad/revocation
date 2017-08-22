class CreateRemarks < ActiveRecord::Migration[5.0]
  def change
    create_table :remarks do |t|
      t.string :heading, null: false, limit: 100
      t.text :message
      t.string :status, limit: 20, default: 'inactive'
      t.string :user_name, limit: 20
      t.string :user_institution, limit: 30
      t.string :user_avatar_url, limit: 50

      t.timestamps
    end
  end
end
