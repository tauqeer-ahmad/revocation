class SectionStudent < ApplicationRecord
  after_commit :reindex_student

  belongs_to :student
  belongs_to :section
  belongs_to :term
  belongs_to :klass

  def reindex_student
    student.reindex
  end
end
