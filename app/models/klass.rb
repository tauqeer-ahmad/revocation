class Klass < ApplicationRecord
  include SearchWrapper
  include GlobalParanoiable
  include SearchCallbackable


  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:name]

  belongs_to :institution
  has_many :sections
  has_many :exam_timetables
  has_many :marksheets
  has_many :exam_marks
  has_many :question_papers

  validates :name, presence: { message: 'Class name is required' }
  validates :code, presence: { message: 'Class code is required' }

  def search_data
    {
      name: name,
      code: code,
      deleted_in_term_id: deleted_in_term_id,
      deleted_at: deleted_at,
    }
  end

  def current_sections(term_id)
    sections.of_current_term(term_id)
  end

  def get_subjects
    section_ids = sections.collect(&:id)
    subject_ids = SectionSubjectTeacher.where(klass_id: self.id, section_id: section_ids).collect(&:id)
    Subject.where(id: subject_ids)
  end
end
