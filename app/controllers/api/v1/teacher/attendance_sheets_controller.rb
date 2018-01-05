class Api::V1::Teacher::AttendanceSheetsController < Api::V1::Teacher::TeacherBaseController
  def index
     @attendance_sheets = AttendanceSheet.api_hash(params, current_user, current_term)
     render json: @attendance_sheets
  end
end
