class AddColumnTermIdToConversation < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :term_id, :integer, index: true
  end
end
