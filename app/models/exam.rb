class Exam < ApplicationRecord
  include SearchWrapper

  searchkick index_name: tenant_index_name

  belongs_to :term
  has_many :exam_timetables, dependent: :destroy
  has_many :exam_marks
  has_many :marksheets
  has_many :question_papers

  validates :name, :start_date, presence: true
  validates :name, uniqueness: {scope: [:term_id]}

  scope :of_current_term, -> (term_id) { where(term_id: term_id) }

  def search_data
    {
      name: name,
      start_date: start_date,
      term_id: term_id,
    }
  end

  def start_date
    date = self[:start_date]
    return nil unless date
    date.strftime("%d/%m/%Y")
  end
end
