class ExamSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :start_date, :comment, :created_at, :updated_at
  has_many :exam_timetables
  has_many :exam_marks

  def exam_marks
    student_id = instance_options[:student_id]
    object.exam_marks.where(student_id: student_id)
  end
end
