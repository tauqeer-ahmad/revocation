class AddColumnColorNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :color, :string, limit: 7, default: '#ffffcc'
  end
end
