class AddPromotedToSectionUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :section_students, :promoted, :boolean, default: false
  end
end
