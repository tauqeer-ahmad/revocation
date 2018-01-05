class Grade < ApplicationRecord
  acts_as_sortable
  belongs_to :grading_system

  validates :name, presence: {message: "Field is required"}
  validates :start_point, presence: {message: "Field is required"}
  validates :end_point, presence: {message: "Field is required"}
  default_scope { order(position: :asc) }
end
