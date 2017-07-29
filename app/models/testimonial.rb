class Testimonial < ApplicationRecord
  belongs_to :user

  scope :active, -> { where(status: 'active') }

  def active?
    self.status == 'active'
  end
end
