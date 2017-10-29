class AddKlassIdAndSectionIdToExams < ActiveRecord::Migration[5.0]
  def change
    add_reference :exams, :klass, index: true
    add_reference :exams, :section, index: true
  end
end
