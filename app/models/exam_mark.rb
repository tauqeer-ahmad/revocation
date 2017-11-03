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

  private

  def update_actual_obtained
    if "obtained".in?(changed) || "total".in?(changed)
      percentage = self.exam.percentage
      self.actual_obtained = ((self.obtained.to_f/self.total.to_f)*100) * (percentage.to_f/100)
    end
  end
end
