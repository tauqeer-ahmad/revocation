class Api::V1::Guardian::ExamsController < Api::V1::Guardian::GuardianBaseController
  before_action :set_exam, only: [:show, :results]

  def index
    @exams = current_term.exams.includes(exam_timetables: [:subject, :klass])
    render json: @exams
  end

  def results
    @exam = @exams.eager_load(exam_marks: [:subject, :section, :klass]).where("exam_marks.student_id =?", selected_user.id).first
    render json: @exam, serializer: ExamResultsSerializer
  end

  def show
    @exam = @exams.includes(exam_timetables: [:subject, :klass]).first
    render json: @exam, serializer: ExamShowSerializer
  end

  private
  def set_exam
    @exams = current_term.exams.where(id: params[:id])
    return record_not_found if @exams.blank?
  end
end
