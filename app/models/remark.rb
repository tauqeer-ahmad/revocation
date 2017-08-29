class Remark < ApplicationRecord
  include AASM

  acts_as_paranoid

  belongs_to :user

  validates :heading, :message, :user_name, :user_institution, :user_avatar_url, presence: true

  LIMIT_FOR_LANDING = 9

  aasm column: :status, whiny_transitions: false do
    state :active
    state :inactive

    event :activate do
      transitions to: :active
    end

    event :inactivate do
      transitions to: :inactive
    end
  end
end
