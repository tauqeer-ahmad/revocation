class SubjectSchedule < ApplicationRecord
  include SearchWrapper

  acts_as_paranoid

  searchkick index_name: tenant_index_name

  belongs_to :teacher
  belongs_to :subject
  belongs_to :section
  belongs_to :term
  belongs_to :klass

  scope :of_term, -> (term_id) { where(term_id: term_id) }

  def search_data
    attributes.merge({
      term_name: term.name,
      teacher_name: teacher.name,
      klass_name: klass.name,
      section_name: section.name,
      subject_name: subject.name,
    })
  end
end
