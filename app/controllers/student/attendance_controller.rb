class Student::AttendanceController < ApplicationController
  def report
    @formated_results,
    @key_to_dates,
    @month_statistics,
    @month_late_statistics,
    @attendances,
    @start_range,
    @end_range = StudentAttendance.fetch_report_data_for_single(params, current_term.id, selected_user.id)

    @section = selected_user.current_section(current_term.id)
  end
end
