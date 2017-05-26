class AddTermToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_reference :attendances, :term, foreign_key: true, index: true
  end
end
