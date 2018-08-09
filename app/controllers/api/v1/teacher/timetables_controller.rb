class Api::V1::Teacher::TimetablesController < Api::V1::Teacher::TeacherBaseController
  def index
    @timetables = current_user.subject_time_tables(current_term)
    render json: @timetables
  end
end
