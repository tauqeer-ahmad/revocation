class Student::AttendanceController < ApplicationController
  def report
    params[:student_id] = current_user.id

    @formated_results, @key_to_dates, @month_statistics, @month_late_statistics, @attendances, @start_range, @end_range, @section = StudentAttendance.fetch_report_data(params, current_term)

    @section = current_user.current_section(current_term.id)
  end
end
