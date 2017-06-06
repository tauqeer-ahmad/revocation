class QuestionPaper < ApplicationRecord
  include SearchWrapper
  searchkick index_name: tenant_index_name

  belongs_to :teacher
  belongs_to :subject
  belongs_to :section
  belongs_to :exam
  belongs_to :term
  belongs_to :klass

  scope :of_section, -> (section) { where(section_id: section) }
  scope :of_subject, -> (subject) { where(subject_id: subject) }

  def search_data
    attributes.merge({
      term_name: term.name,
      teacher_name: teacher.name,
      klass_name: klass.name,
      section_name: section.name,
      exam_name: exam.name,
      subject_name: subject.name,
    })
  end
end
