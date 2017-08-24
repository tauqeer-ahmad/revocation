class Term < ApplicationRecord
  include AASM
  include SearchWrapper

  acts_as_paranoid

  searchkick index_name: tenant_index_name

  has_many :enrolled_students, class_name: 'Student', foreign_key: 'enrollment_term_id'
  has_many :section_students
  has_many :students, through: :section_students
  has_many :sections, dependent: :destroy
  has_many :exams, dependent: :destroy
  has_many :attendance_sheets
  has_many :attendances
  has_many :assignments
  has_many :exam_timetables, dependent: :destroy
  has_many :marksheets, dependent: :destroy
  has_many :exam_marks, dependent: :destroy
  has_many :question_papers

  validates :name, presence: {message: "is required"}
  validates :start_date, presence: {message: "is required"}
  validates :end_date, presence: {message: "is required"}

  validates :name, :uniqueness => {message: "already exists"}
  validate :status_integrity, if: :status_changed?

  def search_data
    {
      name: name,
      status: status,
    }
  end

  aasm requires_lock: true, column: 'status' do
    state :initialized
    state :active
    state :completed

    event :reinitialize do
      transitions from: [:initialized, :active], to: :initialized
    end

    event :active do
      transitions from: [:initialized, :completed], to: :active
    end

    event :complete do
      transitions from: [:active], to: :completed
    end
  end

  def display_term_duration
    [start_date.strftime("%d, %B %y"), 'to', end_date.strftime("%d, %B %y")].join(' ')
  end

  def status_integrity
    return if self.completed?

    status_counts = Term.group(:status).count
    return errors.add(:status, "One Active Term allowed.") if self.active? && status_counts['active'].to_i >= 1
    return errors.add(:status, "One Initialized Term allowed.") if self.initialized? && status_counts['initialized'].to_i >= 1
  end

  def self.active_term
    active.first
  end

  def update_state(new_status)
    return true if self.persisted? && self.status == new_status

    return self.complete! if new_status == 'completed'
    return self.active! if new_status == 'active'
    return self.reinitialize! if new_status == 'initialized'

    rescue => e
      message = self.persisted? ? e.message : 'Initialized Term Already exists.'
      errors.add(:status, message)
      return false
  end

  def display_name
    [name, display_term_duration].join(' ')
  end
end
