class Administrator::StudentAttendancesController < ApplicationController
  def index
  end

  def new
  end

  def create
    @section = current_term.sections.find(params[:section_id])
    if @section.update(attentance_params)
      return redirect_to(new_administrator_student_attendance_path, notice: "Attendance has been marked successfully.")
    else
      return redirect_to(new_administrator_student_attendance_path, alert: "Error: Some thing went wrong")
    end
  end

  def list
    @date = params[:date]
    @section = Section.find(params[:section_id])
    @students = @section.students.order(id: :asc)
    @grouped_students = @students.group_by(&:id)
    @attendances = @section.student_attendances.includes(:student).of_day(params[:date]).ordered.to_a
    if @attendances.present?
      existing_student_ids = @attendances.collect(&:student_id)
      new_students = Student.where("id not in(?)", existing_student_ids)
      @students = @students & new_students
    end
    @students.each do |s|
      @attendances << @section.student_attendances.includes(:student).build(student_id: s.id, day: @date)
    end
  end

  private

  def attentance_params
    params[:section][:student_attendances_attributes].each do |key, values|
      params[:section][:student_attendances_attributes][key] = values.merge!({term_id: @section.term_id, section_id: @section.id, klass_id: @section.klass_id})
    end
    params.require(:section).permit(student_attendances_attributes: [:id, :day, :late, :status, :remarks, :send_sms, :term_id, :student_id, :section_id, :klass_id])
  end
end
