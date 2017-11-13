class GradingSystem < ApplicationRecord
  acts_as_sortable
  has_many :grades
  has_many :sections

  accepts_nested_attributes_for :grades, allow_destroy: true
  validates :name, presence: {message: "Name field is mandatory" }
  default_scope { order(position: :asc) }
end
