class AttendanceSheet < ApplicationRecord
  has_many :attendances, dependent: :destroy
  belongs_to :section

  after_update :update_counters

  accepts_nested_attributes_for :attendances

  enum entity: [:student, :teacher]

  scope :ordered, -> {order(name: :desc)}

  def create_or_build_records(section = nil)
    return build_students if section
    return build_teachers
  end

  def build_students
    section.students.each do |student|
      self.attendances.build(attendee_id: student.id, attendee_type: 'Student')
    end
  end

  def build_teachers
    Teacher.all.each do |teacher|
      self.attendances.build(attendee_id: teacher.id, attendee_type: 'Teacher')
    end
  end

  def update_counters
    counters = attendances.group(:status).count
    update_columns(present: counters['present'], absent: counters['absent'], leave: counters['leave'])
  end
end