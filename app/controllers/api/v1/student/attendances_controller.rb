class Api::V1::Student::AttendancesController < Api::V1::Student::StudentBaseController
  def index
    @attendances = StudentAttendance.for_month_and_year(params[:month], params[:year])
                                    .of_student_and_term(current_user.id, current_term.id)

    render json: @attendances
  end
end
