class Exam < ApplicationRecord
  include SearchWrapper

  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:name]

  belongs_to :term
  has_many :exam_timetables, dependent: :destroy
  has_many :exam_marks
  has_many :marksheets
  has_many :question_papers

  validates :name, :start_date, presence: true
  validates :name, uniqueness: {scope: [:term_id]}

  scope :of_current_term, -> (term_id) { where(term_id: term_id) }
  scope :of_class_and_term, -> (klass_id, term_id) { includes(exam_timetables: :subject).where(exam_timetables: {klass_id: klass_id, term_id: term_id}) }

  def search_data
    {
      name: name,
      start_date: start_date,
      term_id: term_id,
    }
  end

  def start_date
    date = self[:start_date]
    return nil unless date
    date.strftime("%d/%m/%Y")
  end

  def self.exam_events(current_user, current_term)
    exams = Exam.of_class_and_term(current_user.klasses.last.id, current_term.id)

    events = exams.collect do |exam|
               exam.exam_timetables.collect do |exam_timetable|
                 {
                   title: [exam.name, ' of ', exam_timetable.subject.try(:name), ' at ', exam_timetable.start_time.strftime('%-I:%M %p')].join,
                   start: exam_timetable.paper_date.to_time,
                   color: exam_timetable.get_exam_color,
                   className: ['text-center', 'exam-event'],
                   allDay: true,
                 }
               end
             end
    events.flatten
  end
end
