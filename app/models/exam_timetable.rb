class ExamTimetable < ApplicationRecord
  belongs_to :term
  belongs_to :exam
  belongs_to :klass
  belongs_to :subject

  scope :by_paper_date, -> {order(paper_date: :asc).group_by(&:paper_date)}

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
    subject.try(:name)
  end
end