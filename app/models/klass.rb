class Klass < ApplicationRecord
  include SearchWrapper

  searchkick index_name: tenant_index_name

  belongs_to :institution
  has_many :sections
  has_many :exam_timetables
  has_many :marksheets
  has_many :exam_marks

  validates :name, presence: { message: 'Class name is required' }
  validates :code, presence: { message: 'Class code is required' }

  def search_data
    {
      name: name,
      code: code,
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
