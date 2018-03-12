class Administrator::StudentAttendancesController < ApplicationController
  def index
    start_range, end_range = StudentAttendance.get_report_dates(params[:start_range], params[:end_range])
    where_clause = {term_id: current_term.id, day: start_range...end_range}
    where_clause[:section_id] = params[:section_id].to_i if params[:section_id].present?
    @attendances = []
    @section = Section.find(params[:section_id])
    if params[:section_id].present?
      @attendances = StudentAttendance.lookup '', {where: where_clause, order: {day: :asc}}
    end

    @month_statistics = {}
    @month_late_statistics = {}
    @month_grouped = @attendances.group_by { |m| m.day.beginning_of_month }
    @formated_results = {}
    @month_grouped.each_with_index do |(month, records), index|
      key = [Date::MONTHNAMES[month.month], month.year].join('-')
      if start_range.to_date == end_range.to_date
        key = [start_range.strftime("%d %b, %Y")]
      elsif month.month == start_range.month
        key = [start_range.strftime("%d %b, %Y"), month.end_of_month.strftime("%d %b, %Y")].join(' - ')
      elsif month.month == end_range.month
        key = [month.beginning_of_month.strftime("%d %b, %Y"), end_range.strftime("%d %b, %Y")].join(' - ')
      end
      student_grouped = records.group_by(&:student_id)
      @formated_results[key] = student_grouped
      @month_statistics[key] = {Present: 0, Absent: 0, Leave: 0} if @month_statistics[key].blank?
      @month_late_statistics[key] = {"On Time" => 0, Late: 0} if @month_late_statistics[key].blank?
      records.group_by(&:status).map{ |status, r| @month_statistics[key][status.capitalize.to_sym] = ((r.count/records.count.to_f)*100).round(1); r.select{|r| @month_late_statistics[key][:Late] += 1 if r.late?}}
      total_present = @month_statistics[key][:Present]
      @month_late_statistics[key]["On Time"] = (total_present - @month_late_statistics[key][:Late])
      @month_late_statistics[key]["On Time"] = ((@month_late_statistics[key]["On Time"]/total_present)*100).round(1)
      @month_late_statistics[key][:Late] = ((@month_late_statistics[key][:Late]/total_present)*100).round(1)
    end
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
