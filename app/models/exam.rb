class Exam < ApplicationRecord
  acts_as_paranoid

  include AASM
  include SearchWrapper
  include SearchCallbackable


  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:name]

  belongs_to :term
  has_many :exam_timetables, dependent: :destroy
  has_many :exam_marks
  has_many :marksheets
  has_many :question_papers
  has_many :notices, as: :noticeable

  accepts_nested_attributes_for :exam_timetables

  validates :name, :start_date, presence: true
  validates :name, uniqueness: {scope: [:term_id]}

  scope :of_current_term, -> (term_id) { where(term_id: term_id) }
  scope :of_class_and_term, -> (klass_id, term_id) { includes(exam_timetables: :subject).where(exam_timetables: {klass_id: klass_id, term_id: term_id}) }

  def search_data
    {
      name: name,
      start_date: start_date,
      term_id: term_id,
      status: status,
      deleted_at: deleted_at,
    }
  end

  aasm requires_lock: true, column: 'status' do
    state :initialized
    state :active

    event :activate, after: :add_notice do
      transitions from: [:initialized], to: :active
    end

    event :reinitialize do
      transitions from: [:active], to: :initialized
    end
  end

  def start_date
    date = self[:start_date]
    return nil unless date
    date.strftime("%d/%m/%Y")
  end

  def toggle_status
    initialized? ? self.activate! : self.reinitialize!
  end

  def search_name
    name
  end

  def self.exam_events(current_user, current_term)
    student_klass = current_user.klasses.last
    return unless student_klass
    exams = Exam.of_class_and_term(student_klass.id, current_term.id)

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

  def add_notice
    notices.create(
                    title: "#{name} Exam announced.",
                    message: "Starting From #{start_date}",
                    notice_type: 'General',
                  )
  end
end
