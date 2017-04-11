class Klass < ApplicationRecord
  belongs_to :institution
  validates :name, presence: {message: "Class name is required"}
  validates :code, presence: {message: "Class code is required"}
end
