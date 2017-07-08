class Student::AttendanceController < ApplicationController
  def report
    @sheets_by_month = Attendance.of_student_and_term(selected_user.id, current_term.id)
                                 .group_by{ |a| Date::MONTHNAMES[a.attendance_sheet.name.month] }
  end
end
