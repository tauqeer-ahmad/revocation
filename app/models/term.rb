class Term < ApplicationRecord
  include AASM
  include SearchWrapper

  searchkick index_name: tenant_index_name

  has_many :enrolled_students, :class_name => "Student", :foreign_key => "enrollment_term_id" 
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

  validates :name, presence: {message: "Term name is required"}
  validates :start_date, presence: {message: "Term start date is required"}
  validates :end_date, presence: {message: "Term end date is required"}

  validates :name, :uniqueness => {message: "Term already exits for this name"}
  validate :status_integrity

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

    event :active do
      transitions from: [:initialized, :complete], to: :active
    end

    event :complete do
      transitions from: [:active], to: :completed
    end
  end

  def display_term_duration
    [start_date.strftime("%d, %B %Y"), 'to', end_date.strftime("%d, %B %Y")].join(' ')
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
end
