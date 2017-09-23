class Api::V1::Guardian::TimetablesController < Api::V1::Guardian::GuardianBaseController
  def index
    @timetables = selected_user.current_section(current_term.id).timetables.includes(:subject, :klass, :teacher)
    render json: @timetables
  end
end
