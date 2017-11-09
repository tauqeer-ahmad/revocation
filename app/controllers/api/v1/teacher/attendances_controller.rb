class Api::V1::Teacher::AttendancesController < Api::V1::Teacher::TeacherBaseController
  before_action :validate_params

  def index
    @attendances = @attendance_sheet.attendances
    render json: @attendances
  end

  private

    def validate_params
      @attendance_sheet = AttendanceSheet.find params[:attendance_sheet_id]
      return unauthorized_response("Invalid Access") if @attendance_sheet.blank?
    end
end
