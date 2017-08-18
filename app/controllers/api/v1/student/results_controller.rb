class Api::V1::Student::ResultsController < Api::V1::BaseController
  def index
    @exams = current_term.exams.eager_load(exam_marks: [:subject, :section, :klass]).where("exam_marks.student_id =?", current_user.id)
    render json: @exams
  end
end
