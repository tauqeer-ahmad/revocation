class Api::V1::Student::ExamsController < Api::V1::Student::StudentBaseController
  before_action :set_exam, only: [:show]
  def index
    @exams = current_term.exams.includes(exam_timetables: [:subject, :klass])
    render json: @exams, student_id: current_user.id
  end

  def results
    @results = current_user.results_json(current_term)
    render json: @results, status: :ok
  end

  def show
    @exam = @exams.includes(exam_timetables: [:subject, :klass]).first
    render json: @exam, serializer: ExamShowSerializer
  end

  private
  def set_exam
    @exams = current_term.exams.where(id: params[:id])
    return error_response("No exam records found") if @exams.blank?
  end
end
