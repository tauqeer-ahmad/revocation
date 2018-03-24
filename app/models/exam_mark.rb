class ExamMark < ApplicationRecord
  acts_as_paranoid

  belongs_to :markesheet
  belongs_to :term
  belongs_to :exam
  belongs_to :klass
  belongs_to :section
  belongs_to :subject
  belongs_to :student

  scope :by_klass_section_exam, -> (exam_id, klass_id, section_id) { where(exam_id: exam_id, klass_id: klass_id, section_id: section_id) }
  scope :of_current_term, -> (term_id) { where(term_id: term_id) }

  before_save :update_actual_obtained

  def display_status
    obtained >= passing_marks ? "<span class='label label-primary'>Pass</span>".html_safe : "<span class='label label-danger'>Fail</span>".html_safe
  end

  def klass_name
    klass.name
  end

  def section_name
    section.name
  end

  def subject_name
    subject.name
  end

  def grade_map
    self.section.grades
    grade_mappings = {}
    self.section.grades.each do |grade|
      grade_mappings[grade.start_point..grade.end_point] = grade.name
    end
    grade_mappings
  end

  def calculate_percentage(value, total)
    return 0.0 if total.zero?
    '%.1f' % ((value.to_f / total) * 100)
  end

  def assign_grade(percentage, grade_mappings)
    return "-" if grade_mappings.blank?
    grade = grade_mappings.select {|x| x === percentage.to_f}.values.first
    return grade if grade.present?
    "F"
  end

  private

  def update_actual_obtained
    if "obtained".in?(changed) || "total".in?(changed)
      self.grade_map
      percentage = self.exam.percentage
      self.actual_obtained = ((self.obtained.to_f/self.total.to_f)*100) * (percentage.to_f/100)
      self.grade = assign_grade(calculate_percentage(self.actual_obtained, self.exam.percentage.to_f), self.grade_map)
    end
  end
end
