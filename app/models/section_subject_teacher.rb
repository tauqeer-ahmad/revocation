class SectionSubjectTeacher < ApplicationRecord
  belongs_to :teacher
  belongs_to :section
  belongs_to :subject
  belongs_to :klass

  validates :subject_id, presence: {message: "Selection of subject is required"}
  validates :teacher_id, presence: {message: "Selection of teacher is required"}
  validates :subject_id, uniqueness: {scope: :section_id, message: "You can't add two subjects for same section"}

  scope :by_subject_id,        -> (subject_id) { where(subject_id: subject_id) }
  scope :of_term,              -> (term_id)    { where(term_id: term_id) }
  scope :term_teacher_klass,   -> (term_id, teacher_id, klass_id) { where(term_id: term_id, teacher_id: teacher_id, klass_id: klass_id) }
  scope :term_teacher_section, -> (term_id, teacher_id, section_id) { where(term_id: term_id, teacher_id: teacher_id, section_id: section_id) }

  def section_option
    [section.name, section.id]
  end

  def subject_option
    [subject.name, subject.id]
  end
end
