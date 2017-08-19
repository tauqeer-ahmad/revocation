class ExamSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :start_date, :comment, :created_at, :updated_at, :links

  def links
    {
      results: results_api_student_exam_path(object),
      timetable: api_student_exam_path(object)
    }
  end
end
