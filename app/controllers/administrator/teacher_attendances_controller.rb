class Administrator::TeacherAttendancesController < ApplicationController
  layout "pdf", only: [:report]
  before_filter :verify_date_range, only: [:index, :report]
  before_action :set_term_date_ranges, only: [:index]
  def index
    @formated_results, @key_to_dates, @month_statistics, @month_late_statistics, @attendances, @start_range, @end_range, @teachers = TeacherAttendance.fetch_report_data(params, current_term)
  end

  def report
    @start_date = DateTime.parse(params[:start_range]).beginning_of_day
    @end_date = DateTime.parse(params[:end_range]).end_of_day
    @attendances, @report_statistics, @report_late_statistics, @report_range, @teachers = TeacherAttendance.fetch_pdf_report_data(@start_date, @end_date, current_term)
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"Teacher Attendance Report - #{@report_range}.xlsx\""
      }
      format.pdf do
        render pdf: "Teacher's Attendance Report - #{@report_range}",
        disposition: 'attachment',
        template: "administrator/teacher_attendances/report.html.erb",
        layout: 'pdf.html.erb',
        javascript_delay: 500,
        viewport_size: '1200x880',
        zoom: 0.9,
        margin:  {
                    top: 25,
                    bottom: 20
                },
        header: {
                  html: {
                          template: 'shared/pdfs/header',
                          layout: 'pdf_plain',
                          locals: {heading: "Teachers's Attendance Report", left_tag: @report_range}
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

  def set_term_date_ranges
    gon.start_date = current_term.start_date.strftime('%m/%d/%Y')
    gon.end_date = current_term.end_date.strftime('%m/%d/%Y')
  end

  def verify_date_range
    return if params[:start_range].blank? || params[:end_range].blank?

    start_date = Date.parse(params[:start_range])
    end_date = Date.parse(params[:end_range])

    if start_date < current_term.start_date || end_date > current_term.end_date
      return redirect_back(fallback_location: root_path, alert: 'Invalid DateRange Given.')
    end
  end
end
