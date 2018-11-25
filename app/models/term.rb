class Term < ApplicationRecord
  acts_as_paranoid

  include AASM
  include SearchWrapper
  include SearchCallbackable

  searchkick index_name: tenant_index_name

  has_paper_trail

  has_many :enrolled_students, class_name: 'Student', foreign_key: 'enrollment_term_id'
  has_many :section_students
  has_many :students, through: :section_students
  has_many :sections, dependent: :destroy
  has_many :exams, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :exam_timetables, dependent: :destroy
  has_many :marksheets, dependent: :destroy
  has_many :exam_marks, dependent: :destroy
  has_many :question_papers, dependent: :destroy
  has_many :subject_schedules, dependent: :destroy
  has_many :student_attendances, dependent: :destroy
  has_many :teacher_attendances, dependent: :destroy
  has_many :diary_notes, dependent: :destroy

  validates :name, presence: {message: "Name is mandatory"}
  validates :start_date, presence: {message: "Start date is mandatory"}
  validates :end_date, presence: {message: "End date is mandatory"}

  validates :name, uniqueness: {message: "Name already exists"}
  validates :end_date, in_future: { after_or_equal_to: :start_date, comparison: :gte, name: 'term[start_date]', message: "End date can't be before start date"}
  validates :start_date, in_future: { after_or_equal_to: :end_date, comparison: :lte, name: 'term[end_date]', message: "start can't be after end date"}
  validate :status_integrity, if: :status_changed?

  accepts_nested_attributes_for :teacher_attendances, allow_destroy: true

  def search_data
    {
      name: name,
      status: status,
      deleted_at: deleted_at,
    }
  end

  aasm requires_lock: true, column: 'status' do
    state :initialized
    state :active
    state :completed

    event :reinitialize, after: :update_complete_term do
      transitions from: [:initialized, :active], to: :initialized
    end

    event :active do
      transitions from: [:initialized, :completed], to: :active
    end

    event :complete, after: :update_active_term do
      transitions from: [:active], to: :completed
    end
  end

  def update_complete_term
    Term.completed.last.active! if Term.completed.last.present?
  end

  def update_active_term
    Term.initialized.first.active!
  end

  def display_term_duration
    [start_date.strftime("%d, %B %y"), 'to', end_date.strftime("%d, %B %y")].join(' ')
  end

  def status_integrity
    return if self.completed?

    status_counts = Term.group(:status).count
    return errors.add(:status, "One Active Term allowed.") if self.active? && status_counts['active'].to_i >= 1
    return errors.add(:status, "One Initialized Term allowed.") if self.initialized? && status_counts['initialized'].to_i >= 2
  end

  def self.active_term
    active.first
  end

  def update_state(new_status)
    return true if self.persisted? && self.status == new_status
    status_integrity if self.new_record?

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
