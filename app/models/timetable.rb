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
  validates :subject_id, uniqueness: { scope: [:section_id, :day_of_week], message: "Subject has already been added to timetable" }

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

  def self.events(timetables)
    today = Date.today
    week_dates = (today.at_beginning_of_week..today.at_end_of_week).map(&:to_s)
    events = []

    timetables.each do |day, records|
      records.each do |record|
        teacher = record.teacher

        events << {
          id: record.id,
          title: record.subject_name,
          start: [week_dates[day.pred], record.start_time.strftime('%T')].join(' '),
          end: [week_dates[day.pred], record.end_time.strftime('%T')].join(' '),
          color: record.subject.color,
          teacher_id: teacher.id,
          teacher_name: teacher.name,
          section_id: record.section.id,
          className: ['text-center', 'timetable-event'],
          allDay: false,
        }
      end
    end

    events
  end
end
