class StudentAttendance < ApplicationRecord
  include SearchWrapper
  include SearchCallbackableWithoutParanoia

  belongs_to :section
  belongs_to :student
  belongs_to :klass
  belongs_to :term

  scope :of_day, -> (date) {where(day: date)}
  scope :ordered, -> {order(student_id: :asc)}

  searchkick index_name: tenant_index_name

  def search_data
    {
      day: day,
      klass_name: klass.name,
      klass_id: klass_id,
      student_id: student_id,  
      section_id: section_id,
      section_name: section.name,
      sutdent_name: student.full_name,
      term_id: term_id,
    }
  end

  def search_name
    "Student Attendance #{klass.name} - #{section.name}"
  end
  
  def self.get_report_dates(start_date, end_date)
    [Date.parse(start_date).beginning_of_day, Date.parse(end_date).end_of_day]
  end
end
