class Api::V1::Student::AttendancesController < Api::V1::Student::StudentBaseController
  def index
    @attendances = StudentAttendance.of_student_and_term(current_user.id, current_term.id)

    render json: @attendances
  end
end
