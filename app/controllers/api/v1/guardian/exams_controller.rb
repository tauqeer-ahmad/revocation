class Api::V1::Guardian::ExamsController < Api::V1::Guardian::GuardianBaseController
  def index
    @exams = selected_user.current_section(current_term).exams.active.includes(:exam_timetables)

    render json: @exams
  end

  def results
    @results = selected_user.results_json(current_term)

    render json: @results, status: :ok
  end

  def show
    @exam = selected_user.current_section(current_term.id)
                        .exams
                        .find(params[:id])

    render json: @exam, exam_timetables: true
  end
end
