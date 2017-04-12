class Term < ApplicationRecord
  belongs_to :institution
  has_many :sections, dependent: :destroy

  validates :name, presence: {message: "Term name is required"}
  validates :start_date, presence: {message: "Term start date is required"}
  validates :end_date, presence: {message: "Term end date is required"}
  validates :institution_id, presence: true
  
  validates :name, :uniqueness => {:scope => :institution_id, message: "Term already exits for this name"}
  
  def display_term_duration
    [start_date.strftime("%d, %B %Y"), 'to', end_date.strftime("%d, %B %Y")].join(' ')
  end
end
