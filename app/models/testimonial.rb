class Testimonial < ApplicationRecord
  belongs_to :user

  scope :active, -> { where(status: 'active') }

  validates :heading, :message, presence: true

  def active?
    self.status == 'active'
  end
end
