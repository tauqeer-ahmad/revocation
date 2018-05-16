class Assignment < ApplicationRecord
  include AASM
  acts_as_paranoid

  belongs_to :teacher
  belongs_to :section
  belongs_to :subject
  belongs_to :term
  has_many :notices, as: :noticeable

  scope :of_section, -> (section) { where(section_id: section) }
  scope :of_subject, -> (subject) { where(subject_id: subject) }
  scope :ordered,    ->           { order(:submission_deadline) }

  scope :of_section_and_term, -> (section_id, term_id) { where(section_id: section_id, term_id: term_id) }
  scope :of_subjects_and_term, -> (subject_ids, term_id) { where(subject_id: subject_ids, term_id: term_id) }

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

  def get_assignment_color
    if Date.today == submission_deadline.to_date
      '#1ab394'
    elsif Date.today > submission_deadline.end_of_day
      '#ed5565'
    else
      '#f8ac59'
    end
  end

  def self.assignment_events(current_user, current_term)
    student_section = current_user.sections.last
    return unless student_section
    assignments = Assignment.of_section_and_term(student_section.id, current_term.id)

    assignments.collect do |assignment|
      {
        title: ['Assignment: ', assignment.heading, 'due at', assignment.submission_deadline.strftime('%-d %b %Y %-I:%M %p')].join,
        start: assignment.submission_deadline,
        color: assignment.get_assignment_color,
        className: ['text-center', 'assignment-event'],
        allDay: true,
      }
    end
  end

  def self.teacher_assignment_events(current_user, current_term)
    subject_ids = current_user.section_subject_teachers.pluck(:subject_id)
    return {} unless subject_ids
    assignments = includes(:subject, :section).of_subjects_and_term(subject_ids, current_term.id)

    assignments.collect do |assignment|
      {
        title: ['Assignment:', assignment.heading, assignment.subject&.name, assignment.section&.name, 'due at', assignment.submission_deadline.strftime('%-d %b %Y %-I:%M %p')].join(' '),
        start: assignment.submission_deadline,
        color: assignment.get_assignment_color,
        className: ['text-center', 'assignment-event'],
        allDay: true,
      }
    end
  end

  def toggle_status
    initialized? ? self.activate! : self.reinitialize!
  end

  def add_notice
    notices.create(
                    title: "New #{subject.name}'s Assignment",
                    message: heading,
                    klass_id: section.klass_id,
                    section_id: section.id,
                    notice_type: 'Section Specific',
                  )
  end
end
