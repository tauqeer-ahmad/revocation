class ExamTimetable < ApplicationRecord
  acts_as_paranoid

  validates :klass_id, presence: {message: "Class is a mandatory field"}
  validates :section_id, presence: {message: "Section is a mandatory field"}
  validates :subject_id, presence: {message: "Subject is a mandatory field"}
  validates :paper_date, presence: {message: "Paper date is a mandatory field"}
  validates :start_time, presence: {message: "Start time is a mandatory field"}
  validates :end_time, presence: {message: "End time is a mandatory field"}

  belongs_to :term
  belongs_to :exam
  belongs_to :klass
  belongs_to :subject
  belongs_to :section

  scope :by_paper_date, -> {order(paper_date: :asc).group_by(&:paper_date)}
  scope :by_klass, -> (klass_id) { where(klass_id: klass_id) }

  def list_subjects
    SectionSubjectTeacher.where(klass_id: self.klass_id, term_id: self.term_id)
  end

  def paper_date
    date = self[:paper_date]
    return nil unless date
    date.strftime("%d/%m/%Y")
  end

  def get_start_time
    start_time.strftime("%I:%M %p") if start_time
  end

  def get_end_time
    end_time.strftime("%I:%M %p") if end_time
  end

  def timings
    [get_start_time, get_end_time].join(' - ')
  end

  def klass_name
    klass.try(:name)
  end

  def subject_name
    subject&.name
  end

  def subject_color
    subject&.color
  end

  def get_exam_color
    if Date.today == paper_date.to_date
      '#1ab394'
    elsif Date.today > paper_date.to_date
      '#ed5565'
    else
      '#f8ac59'
    end
  end
end
