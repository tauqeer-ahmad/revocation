class Assignment < ApplicationRecord
  acts_as_paranoid

  belongs_to :teacher
  belongs_to :section
  belongs_to :subject
  belongs_to :term

  scope :of_section, -> (section) { where(section_id: section) }
  scope :of_subject, -> (subject) { where(subject_id: subject) }
  scope :ordered,    ->           { order(:submission_deadline) }

  scope :of_section_and_term, -> (section_id, term_id) { where(section_id: section_id, term_id: term_id) }

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
        title: ['Assignment: ', assignment.heading].join,
        start: assignment.submission_deadline,
        color: assignment.get_assignment_color,
        className: ['text-center', 'assignment-event'],
        allDay: true,
      }
    end
  end
end
