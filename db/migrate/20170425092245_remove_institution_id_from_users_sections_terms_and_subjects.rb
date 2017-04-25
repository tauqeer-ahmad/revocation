class RemoveInstitutionIdFromUsersSectionsTermsAndSubjects < ActiveRecord::Migration[5.0]
  def change
    remove_column :section_subject_teachers, :institution_id
    remove_column :sections, :institution_id
    remove_column :terms, :institution_id
    remove_column :subjects, :institution_id
    remove_column :klasses, :institution_id
    remove_column :users, :institution_id
  end
end
