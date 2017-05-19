class Exam < ApplicationRecord
  belongs_to :term

  validates :name, :start_date, presence: true
  validates :name, uniqueness: {scope: [:term_id]}

  def start_date
    date = self[:start_date]
    return nil unless date
    date.strftime("%d/%m/%Y")
  end
end
