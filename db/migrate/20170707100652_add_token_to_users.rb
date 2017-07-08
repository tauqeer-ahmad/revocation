class AddTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :access_token, :string, limit: 20, index: true
  end
end
