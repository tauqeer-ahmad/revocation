class DiaryNote < ApplicationRecord
  belongs_to :teacher
  belongs_to :section
  belongs_to :subject
  belongs_to :term
  belongs_to :student

  scope :of_section, -> (section) { where(section_id: section) }
  scope :for_section_and_student, -> (section_id, student_id) { where("(diary_notes.section_id = ? AND diary_notes.student_id IS NULL) OR diary_notes.student_id = ?", section_id, student_id) }
  scope :of_subject, -> (subject) { where(subject_id: subject) }
  scope :ordered,    ->           { order(note_for: :desc) }

  scope :of_section_and_term, -> (section_id, term_id) { where(section_id: section_id, term_id: term_id) }
  scope :of_subjects_and_term, -> (subject_ids, term_id) { where(subject_id: subject_ids, term_id: term_id) }
end
