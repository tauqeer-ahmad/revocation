class ExamMark < ApplicationRecord
  belongs_to :markesheet
  belongs_to :term
  belongs_to :exam
  belongs_to :klass
  belongs_to :section
  belongs_to :subject
  belongs_to :student
end
