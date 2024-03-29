class Klass < ApplicationRecord
  acts_as_sortable
  include SearchWrapper
  include GlobalParanoiable
  include SearchCallbackable


  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:name]

  belongs_to :institution
  has_many :sections
  has_many :exam_timetables
  has_many :exams, dependent: :destroy
  has_many :marksheets
  has_many :exam_marks
  has_many :question_papers
  has_many :subject_schedules
  has_many :student_attendances

  validates :name, presence: { message: 'Class name is mandatory' }
  validates :code, presence: { message: 'Class code is mandatory' }
  default_scope { order(position: :asc) }

  def search_data
    {
      name: name,
      code: code,
      deleted_in_term_id: deleted_in_term_id,
      deleted_at: deleted_at,
      position: position,
    }
  end

  def search_name
    name
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
