class AddStatusToTerms < ActiveRecord::Migration[5.0]
  def change
    add_column :terms, :status, :string
  end
end
