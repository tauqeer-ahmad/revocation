class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :body, null: false
      t.string :status, null: false, default: 'unread'
      t.references :conversation, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
