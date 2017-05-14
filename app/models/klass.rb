class Klass < ApplicationRecord
  belongs_to :institution
  has_many :sections

  validates :name, presence: { message: 'Class name is required' }
  validates :code, presence: { message: 'Class code is required' }
end
