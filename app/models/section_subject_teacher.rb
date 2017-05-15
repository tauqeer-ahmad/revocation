class SectionSubjectTeacher < ApplicationRecord
  belongs_to :teacher
  belongs_to :section
  belongs_to :subject
  belongs_to :klass

  validates :subject_id, presence: {message: "Selection of subject is required"}
  validates :teacher_id, presence: {message: "Selection of teacher is required"}
  validates :section_id, uniqueness: {scope: [:teacher_id, :subject_id, :klass_id , :term_id]}

  scope :by_subject_id, -> (subject_id) { where(subject_id: subject_id) }
end
