class AddInstituitionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :institution, index: true, foreign_key: true
  end
end
