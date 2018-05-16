class Exam < ApplicationRecord
  acts_as_paranoid

  include AASM
  include SearchWrapper
  include SearchCallbackable


  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:name]

  belongs_to :term
  belongs_to :klass
  belongs_to :section
  has_many :exam_timetables, dependent: :destroy
  has_many :exam_marks, dependent: :destroy
  has_many :marksheets, dependent: :destroy
  has_many :question_papers, dependent: :destroy
  has_many :notices, as: :noticeable, dependent: :destroy

  accepts_nested_attributes_for :exam_timetables

  validates :klass_id, presence: {message: "Class is a mandatory field"}
  validates :section_id, presence: {message: "Section is a mandatory field"}
  validates :name, presence: {message: "Name feild is mandatory"}
  validates :start_date, presence: {message: "Start feild is mandatory"}
  validates :name, uniqueness: {scope: [:term_id, :section_id], message: "Name already exists."}
  validates :percentage, presence: {message: "Percentage is a mandatory field."}
  validates :percentage, inclusion: { in: 0..100, message: "The percentage must be between 0 and 100" }

  scope :of_current_term, -> (term_id) { where(term_id: term_id) }
  scope :of_class_and_term, -> (klass_id, term_id) { includes(exam_timetables: :subject).where(exam_timetables: {klass_id: klass_id, term_id: term_id}) }
  scope :of_subjects_and_term, -> (subject_ids, term_id) { includes(exam_timetables: [:section, :subject]).where(exam_timetables: {subject_id: subject_ids, term_id: term_id} ) }

  def search_data
    {
      name: name,
      start_date: start_date,
      term_id: term_id,
      section_id: section_id,
      klass_id: klass_id,
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
                   title: [exam.name, ' of ', exam_timetable.subject.try(:name) ,' at ', exam_timetable.start_time.strftime('%-I:%M %p')].join,
                   start: exam_timetable.paper_date.to_time,
                   color: exam_timetable.get_exam_color,
                   className: ['text-center', 'exam-event'],
                   allDay: true,
                 }
               end
             end
    events.flatten
  end

  def self.exam_teacher_events(current_user, current_term)
    subject_ids = current_user.section_subject_teachers.pluck(:subject_id)
    return unless subject_ids
    exams = Exam.of_subjects_and_term(subject_ids, current_term.id)

    events = exams.collect do |exam|
               exam.exam_timetables.collect do |exam_timetable|
                 {
                   title: ['Exam:', exam.name, 'of', exam_timetable.subject.try(:name), 'of section', exam_timetable.section&.name , 'at', exam_timetable.start_time.strftime('%-I:%M %p')].join(' '),
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
