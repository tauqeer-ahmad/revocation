class Marksheet < ApplicationRecord
  acts_as_paranoid

  include SearchWrapper
  include SearchCallbackable


  searchkick index_name: tenant_index_name

  has_many :exam_marks
  belongs_to :term
  belongs_to :exam
  belongs_to :klass
  belongs_to :section
  belongs_to :subject

  accepts_nested_attributes_for :exam_marks

  scope :existing_marksheet, -> (term_id, exam_id, klass_id, section_id, subject_id) { where(term_id: term_id, exam_id: exam_id, klass_id: klass_id, section_id: section_id, subject_id: subject_id) }
  scope :of_current_term, -> (term_id) { where(term_id: term_id) }

  def search_data
    attributes.merge({
      klass_name: klass.name,
      section_name: section&.name,
      exam_name: exam.name,
      subject_name: subject.name,
      term_id: term_id,
      deleted_at: deleted_at,
    })
  end
end
