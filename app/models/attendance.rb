class Attendance < ApplicationRecord
  acts_as_paranoid

  belongs_to :attendee, polymorphic: true
  belongs_to :attendance_sheet
  belongs_to :term

  enum status: [:present, :absent, :leave]

  scope :of_student_and_term, -> (student_id, term_id) { includes(:attendance_sheet).where(attendee_type: 'Student', attendee_id: student_id, term_id: term_id) }

  def self.during(year, month)
    if year.present? && month.present?
      date = Date.new(year.to_i, month.to_i)
      return references(:attendance_sheet).where("attendance_sheets.name >= ? and attendance_sheets.name <= ?", date.beginning_of_month, date.end_of_month)
    end

    all
  end

  def self.for_month_and_year(month, year)
    return if month.blank? || year.blank?

    date = Date.new(year.to_i, month.to_i)

    joins(:attendance_sheet)
    .where('attendance_sheets.name >= ? AND attendance_sheets.name <= ?', date.beginning_of_month, date.end_of_month)
  end

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
      {
        title: ['Attendance: ', attendance.status.capitalize].join,
        start: attendance.attendance_sheet.name.to_s,
        color: attendance.get_attendance_color,
        className: ['text-center', 'attendance-event'],
        allDay: true,
      }
    end
  end
end
