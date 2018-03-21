class TeacherAttendance < ApplicationRecord
  belongs_to :term
  belongs_to :teacher

  scope :of_day, -> (date) {where(day: date)}
  scope :ordered, -> {order(teacher_id: :asc)}
end
