class Api::V1::Guardian::AttendancesController < Api::V1::Guardian::GuardianBaseController
  def index
    @attendances = StudentAttendance.of_student_and_term(selected_user.id, current_term.id)

    render json: @attendances
  end
end
