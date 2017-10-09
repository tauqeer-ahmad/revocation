class Teacher::AttendanceSheetsController < ApplicationController
  before_action :set_attendance_sheet, only: [:update, :destroy]
  before_action :set_section, only: :managing_students
  before_action :update_params, only: :update

  def index
    @sections =  current_user.incharged_sections_list(current_term.id)

    sheets = current_term.attendance_sheets.student.of_section(@sections.map(&:first)).includes(:attendances, {section: :klass}).ordered
    @attendance_sheets = sheets.group_by { |entity| entity.name.to_date.strftime('%B-%Y') }
  end

  def managing_students
    @attendance_sheet = current_term.attendance_sheets.find_or_create_by(name: params[:date], section_id: params[:section_id], entity: 'student')
    @attendance_sheet.create_or_build_records(@section) unless @attendance_sheet.attendances.exists?
    @students = @section.student_hash
  end

  def update
    if @attendance_sheet.update(attendance_sheet_params)
      redirect_to redirect_path, notice: 'Attendance sheet was successfully updated.'
    else
      render_path
    end
  end

  def destroy
    @attendance_sheet.destroy
    head :no_content
  end

  private
    def set_attendance_sheet
      @attendance_sheet = current_term.attendance_sheets.find(params[:id])
    end

    def attendance_sheet_params
      params.require(:attendance_sheet).permit(attendances_attributes: [:id, :attendee_id, :attendee_type, :status, :term_id])
    end

    def update_params
      params[:attendance_sheet][:attendances_attributes].each do |key, attendance|
        attendance[:term_id] = current_term.id
        attendance[:attendee_type] = @attendance_sheet.entity.titleize
      end
    end

    def set_section
      @section = current_term.sections.find(params[:section_id])
      redirect_to attendance_sheet_path, error: 'Invalid Access' unless @section
    end

    def redirect_path
      @attendance_sheet.student? ? attendance_sheets_url : teachers_attendance_sheets_url
    end

    def render_path
      if @attendance_sheet.student?
        @attendance_sheet.create_or_build_records(@section) unless @attendance_sheet.attendances.exists?
        @students = @section.student_hash
        managing_students_attendance_sheets_path
      else
        @attendance_sheet.create_or_build_records unless @attendance_sheet.attendances.exists?
        @teachers = Teacher.data_hash
        managing_teachers_attendance_sheets_path
      end
    end
end
