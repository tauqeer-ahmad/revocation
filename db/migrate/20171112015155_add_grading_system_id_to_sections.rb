class AddGradingSystemIdToSections < ActiveRecord::Migration[5.0]
  def change
    add_reference :sections, :grading_system, index: true
  end
end
