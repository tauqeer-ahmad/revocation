class Attendance < ApplicationRecord
  belongs_to :attendee, polymorphic: true
  belongs_to :attendance_sheet
  belongs_to :term

  enum status: [:present, :absent, :leave]
end
