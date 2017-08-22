class CreateNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :notices do |t|
      t.string :title
      t.text :message
      t.string :notice_type
      t.references :klass, foreign_key: true, index: true
      t.references :section, foreign_key: true, index: true

      t.timestamps
    end
  end
end
