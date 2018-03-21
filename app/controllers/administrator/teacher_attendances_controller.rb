class Administrator::TeacherAttendancesController < ApplicationController
  def index
  end

  def new
  end

  def create
    if current_term.update(attentance_params)
      return redirect_to(new_administrator_teacher_attendance_path, notice: "Attendance has been marked successfully.")
    else
      return redirect_to(new_administrator_teacher_attendance_path, alert: "Error: Some thing went wrong")
    end
  end

  def list
    @date = params[:date]
    @teachers = Teacher.order(id: :asc)
    @grouped_teachers = @teachers.group_by(&:id)
    @attendances = current_term.teacher_attendances.includes(:teacher).of_day(@date).ordered.to_a
    if @attendances.present?
      existing_teacher_ids = @attendances.collect(&:teacher_id)
      new_students = @teachers.where("id not in(?)", existing_teacher_ids)
      @teachers = @teachers & new_students
    end
    @teachers.each do |t|
      @attendances << current_term.teacher_attendances.includes(:teacher).build(teacher_id: t.id, day: @date)
    end
  end

  private

  def attentance_params
    params[:term][:teacher_attendances_attributes].each do |key, values|
      params[:term][:teacher_attendances_attributes][key] = values.merge!({term_id: current_term.id})
    end
    params.require(:term).permit(teacher_attendances_attributes: [:id, :day, :late, :status, :remarks, :term_id, :teacher_id, :arrival, :departure])
  end
end
