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
end
