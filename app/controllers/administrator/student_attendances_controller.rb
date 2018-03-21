class Administrator::StudentAttendancesController < ApplicationController
  layout "pdf", only: [:report]
  def index
    @formated_results, @key_to_dates, @month_statistics, @month_late_statistics, @attendances, @start_range, @end_range, @section = StudentAttendance.fetch_report_data(params, current_term)
  end

  def report
    @start_date = DateTime.parse(params[:start_date]).beginning_of_day
    @end_date = DateTime.parse(params[:end_date]).end_of_day
    section_id = params[:section_id]
    @attendances, @report_statistics, @report_late_statistics, @section, @report_range = StudentAttendance.fetch_pdf_report_data(@start_date, @end_date, section_id, current_term)
    return redirect_back(fallback_location: root_path, alert: "No Results found") if @attendances.blank?
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename='#{@section.klass_name} - #{@section.name} - #{@report_range}.xlsx'"
      }
      format.pdf do
        render pdf: "#{@section.klass_name} - #{@section.name} - #{@report_range}",
        disposition: 'attachment',
        template: "administrator/student_attendances/report.html.erb",
        layout: 'pdf.html.erb',
        javascript_delay: 500,
        viewport_size: '1100x880',
        zoom: 0.9,
        margin:  {   
                    top: 25,
                    bottom: 20
                },
        header: {
                  html: { 
                          template: 'shared/pdfs/header',
                          layout: 'pdf_plain',
                          locals: {heading: "Students's Attendance Report", left_tag: @report_range}
                        },
                  line: true,
                  spacing: 6
                },
        footer: {   
                  html: {
                          template:'shared/pdfs/footer',
                          layout:  'pdf_plain',
                          locals: {left_tag: @report_range}
                        },
                  spacing: 6,
                  line:  true
                }
      end
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
