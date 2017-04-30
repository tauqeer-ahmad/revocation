class Term < ApplicationRecord
  has_many :enrolled_students, :class_name => "Student", :foreign_key => "enrollment_term_id" 
  has_many :section_students
  has_many :students, through: :section_students
  has_many :sections, dependent: :destroy

  validates :name, presence: {message: "Term name is required"}
  validates :start_date, presence: {message: "Term start date is required"}
  validates :end_date, presence: {message: "Term end date is required"}

  validates :name, :uniqueness => {message: "Term already exits for this name"}
  
  def display_term_duration
    [start_date.strftime("%d, %B %Y"), 'to', end_date.strftime("%d, %B %Y")].join(' ')
  end
end
