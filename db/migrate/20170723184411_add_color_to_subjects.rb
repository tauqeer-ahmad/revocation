class AddColorToSubjects < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :color, :string, limit: 7, default: '#EB016E'
  end
end
