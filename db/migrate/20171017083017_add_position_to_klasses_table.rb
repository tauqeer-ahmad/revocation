class AddPositionToKlassesTable < ActiveRecord::Migration[5.0]
  def change
    add_column :klasses, :position, :integer
    reversible  do |direction|
      direction.up {
        Klass.order('id desc').each.with_index do |klass, position|
          klass.update_attribute :position, position
        end

        change_column :klasses, :position, :integer, null: false
        add_index :klasses, [:position]
      }
    end
  end
end
