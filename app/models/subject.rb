class Subject < ApplicationRecord
  belongs_to :institution
  has_many :section_subject_teachers
  has_many :sections, through: :section_subject_teachers
  has_many :teachers, through: :section_subject_teachers

  validates :section_id, uniqueness: {scope: [:teacher_id, :subject_id, :klass_id , :term_id, :institution_id]}
end
