class Attendance < ApplicationRecord
  belongs_to :attendee, polymorphic: true
  belongs_to :attendance_sheet

  enum status: [:present, :absent, :leave]
end
