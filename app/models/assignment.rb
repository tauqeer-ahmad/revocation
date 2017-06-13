class Assignment < ApplicationRecord
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
    assignments = Assignment.of_section_and_term(current_user.sections.last.id, current_term.id)

    assignments.collect do |assignment|
      assignment_hash = {}
      assignment_hash[:title] = ['Assignment: ', assignment.heading].join
      assignment_hash[:start] = assignment.submission_deadline
      assignment_hash[:color] = assignment.get_assignment_color
      assignment_hash[:className] = ['text-center', 'assignment-event']
      assignment_hash[:allDay] = true
      assignment_hash
    end
  end
end
