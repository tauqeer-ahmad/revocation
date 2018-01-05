class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.integer :sender_id, foreign_key: true, null: false, index: true
      t.integer :recipient_id, foreign_key: true, null: false, index: true
      t.string :status, null: false, default: 'unread'
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :conversations, [:sender_id, :recipient_id]
  end
end
