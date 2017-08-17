class Remark < ApplicationRecord
  belongs_to :user

  scope :active, -> { where(status: 'active') }

  validates :heading, :message, :user_name, :user_institution, :user_avatar_url, presence: true

  LIMIT_FOR_LANDING = 9

  def active?
    self.status == 'active'
  end
end
