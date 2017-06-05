class Student::HomeController < ApplicationController
  def index
    @attendances = Attendance.includes(:attendance_sheet).where(attendee_type: 'Student', attendee_id: current_user.id, term_id: current_term.id)

    gon.events =  @attendances.collect do |attendance|
                    attendance_hash = {}
                    attendance_hash[:title] = attendance.status.capitalize
                    attendance_hash[:start] = attendance.attendance_sheet.name.to_s
                    attendance_hash[:color] = get_attendance_color(attendance.status)
                    attendance_hash[:className] = ['text-center', 'attendance-event']
                    attendance_hash[:allDay] = true
                    attendance_hash
                  end
  end

  private
    def get_attendance_color(status)
      case status
        when 'present' then '#1ab394'
        when 'absent' then '#ed5565'
        when 'leave' then '#f8ac59'
      end
    end
end
