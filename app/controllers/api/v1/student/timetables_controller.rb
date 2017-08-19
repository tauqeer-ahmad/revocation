class Api::V1::Student::TimetablesController < Api::V1::Student::StudentBaseController
  def index
    @timetables = current_user.current_section(current_term.id).timetables.includes(:subject, :klass, :teacher, :section)
    render json: @timetables
  end
end
