class ExamResultsSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :comment, :created_at, :updated_at

  has_many :exam_marks
end
