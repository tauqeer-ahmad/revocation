class Attendance < ApplicationRecord
  belongs_to :attendee, polymorphic: true
  belongs_to :attendance_sheet
  belongs_to :term

  enum status: [:present, :absent, :leave]

  scope :of_student_and_term, -> (student_id, term_id) { includes(:attendance_sheet).where(attendee_type: 'Student', attendee_id: student_id, term_id: term_id) }

  def get_attendance_color
    case status
      when 'present' then '#1ab394'
      when 'absent' then '#ed5565'
      when 'leave' then '#f8ac59'
    end
  end

  def self.attendance_events(current_user, current_term)
    attendances = Attendance.of_student_and_term(current_user.id, current_term.id)

    attendances.collect do |attendance|
      attendance_hash = {}
      attendance_hash[:title] = ['Attendance: ', attendance.status.capitalize].join
      attendance_hash[:start] = attendance.attendance_sheet.name.to_s
      attendance_hash[:color] = attendance.get_attendance_color
      attendance_hash[:className] = ['text-center', 'attendance-event']
      attendance_hash[:allDay] = true
      attendance_hash
    end
  end
end
