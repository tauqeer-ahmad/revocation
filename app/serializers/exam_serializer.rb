class ExamSerializer < ActiveModel::Serializer
  attributes :name, :start_date, :comment

  has_many :exam_marks
end
