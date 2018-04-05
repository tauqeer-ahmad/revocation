class Teacher::AttendancesController < ApplicationController
  def index
    @teacher = current_user
    @formated_results, @key_to_dates, @month_statistics, @month_late_statistics, @attendances, @report_range, @start_date, @end_date = TeacherAttendance.fetch_teacher_report_data(params, current_term, @teacher)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Attendance Report - #{@teacher.full_name} - #{@report_range}",
        disposition: 'attachment',
        template: "shared/teacher/_attendance_report.html.erb",
        layout: 'pdf.html.erb',
        javascript_delay: 1000,
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
                          locals: {heading: "Teacher Attendance Report", left_tag: @report_range}
                        },
                  line: true,
                  spacing: 1
                },
        footer: {
                  html: {
                          template:'shared/pdfs/footer',
                          layout:  'pdf_plain',
                          locals: {left_tag: @report_range}
                        },
                  spacing: 1,
                  line:  true
                }
      end
    end
  end
end
