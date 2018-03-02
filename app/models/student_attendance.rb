class StudentAttendance < ApplicationRecord
  belongs_to :section
  belongs_to :student
  belongs_to :klass
  belongs_to :term

  scope :of_day, -> (date) {where(day: date)}
  scope :ordered, -> {order(student_id: :asc)}
end
