class Api::V1::Student::ExamsController < Api::V1::Student::StudentBaseController
  def index
    @exams = current_user.current_section(current_term).exams.active.includes(:exam_timetables)

    render json: @exams
  end

  def results
    @results = current_user.results_json(current_term)

    render json: @results, status: :ok
  end

  def show
    @exam = current_user.current_section(current_term.id)
                        .exams
                        .find(params[:id])

    render json: @exam, exam_timetables: true
  end
end
