class Assignment < ApplicationRecord
  belongs_to :teacher
  belongs_to :section
  belongs_to :subject
  belongs_to :term

  scope :of_section, -> (section) { where(section_id: section) }
  scope :of_subject, -> (subject) { where(subject_id: subject) }
  scope :ordered,    ->           { order(:submission_deadline) }
end
