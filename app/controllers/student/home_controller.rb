class Student::HomeController < ApplicationController
  def index
    @attendances = Attendance.of_student(current_user.id, current_term.id)

    gon.attendance_events = @attendances.collect do |attendance|
                              attendance_hash = {}
                              attendance_hash[:title] = attendance.status.capitalize
                              attendance_hash[:start] = attendance.attendance_sheet.name.to_s
                              attendance_hash[:color] = attendance.get_attendance_color
                              attendance_hash[:className] = ['text-center', 'attendance-event']
                              attendance_hash[:allDay] = true
                              attendance_hash
                            end
  end

  def attendance_report
    @sheets_by_month = Attendance.of_student(current_user.id, current_term.id)
                                 .group_by{|a| Date::MONTHNAMES[a.attendance_sheet.name.month] }
  end
end
