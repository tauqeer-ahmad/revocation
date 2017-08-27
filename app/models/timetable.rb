class Timetable < ApplicationRecord
  acts_as_paranoid

  belongs_to :section
  belongs_to :subject
  belongs_to :klass
  belongs_to :term
  belongs_to :teacher

  validates :day_of_week, presence: { message: "Day of week field is required" }
  validates :start_time, presence: { message: "Start time is required" }
  validates :end_time, presence: { message: "End time is required" }
  validates :subject_id, presence: { message: "Selection of a subject is required" }

  scope :by_day_of_week, -> {order(day_of_week: :asc).group_by(&:day_of_week)}

  DAYS = {
    1 => "Monday",
    2 => "Tuesday",
    3 => "Wednesday",
    4 => "Thursday",
    5 => "Friday",
    6 => "Saturday",
    7 => "Sunday",
  }

  def self.get_days_arr
    DAYS.invert.to_a
  end

  def get_day_name
    DAYS[day_of_week]
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

  def teacher_name
    teacher.try(:name)
  end

  def subject_name
    subject&.name
  end

  def subject_color
    subject&.color
  end

  def klass_name
    klass.try(:name)
  end

  def section_name
    section.try(:name)
  end
end
