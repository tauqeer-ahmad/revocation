class Api::V1::Student::AttendancesController < Api::V1::Student::StudentBaseController
  def index
    @attendances = Attendance.of_student_and_term(selected_user.id, current_term.id).during(params[:year], params[:month])
    render json: @attendances
  end
end
