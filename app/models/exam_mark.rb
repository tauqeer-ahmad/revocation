class ExamMark < ApplicationRecord
  belongs_to :markesheet
  belongs_to :term
  belongs_to :exam
  belongs_to :klass
  belongs_to :section
  belongs_to :subject
  belongs_to :student

  scope :by_klass_section_exam, -> (exam_id, klass_id, section_id) { where(exam_id: exam_id, klass_id: klass_id, section_id: section_id) }
  scope :of_current_term, -> (term_id) { where(term_id: term_id) }
end
