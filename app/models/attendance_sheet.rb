class AttendanceSheet < ApplicationRecord
  acts_as_paranoid

  has_many :attendances, dependent: :destroy

  belongs_to :section
  belongs_to :term

  after_update :update_counters

  accepts_nested_attributes_for :attendances

  enum entity: [:student, :teacher]

  scope :of_section, -> (section) { where(section_id: section) }
  scope :ordered, -> {order(name: :desc)}

  def create_or_build_records(section = nil)
    return build_students if section
    return build_teachers
  end

  def build_students
    section.students.each do |student|
      self.attendances.build(attendee_id: student.id)
    end
  end

  def build_teachers
    Teacher.all.each do |teacher|
      self.attendances.build(attendee_id: teacher.id)
    end
  end

  def update_counters
    counters = attendances.group(:status).count
    update_columns(present: counters['present'], absent: counters['absent'], leave: counters['leave'])
  end

  def self.monthly_grouped
    group_by { |entity| entity.name.to_date.strftime('%B-%y') }
  end

  def self.api_hash(params, current_user, current_term)
    sections =  current_user.incharged_sections_list(current_term.id)
    sections =  sections.select { |section_id, name| section_id == params[:section_id].to_i } if params[:section_id].present?

    attendance_sheets = {}
    sheets = current_term.attendance_sheets.student.of_section(sections.map(&:first)).ordered.select(:id, :name, :present, :absent, :leave, :section_id)
    sheets = sheets.group_by { |entity| entity.name.to_date.strftime('%B-%Y') }
    sheets.each do |key, value| attendance_sheets[key] = value.group_by { |entity| entity.section_id } end

    attendance_sheets
  end
end
