class AddStatusToTerms < ActiveRecord::Migration[5.0]
  def change
    add_column :terms, :status, :string, limit: 16, index: true
  end
end
