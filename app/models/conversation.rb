class Conversation < ApplicationRecord
  include AASM

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  has_many :messages, dependent: :destroy
  has_many :users, through: :messages

  validates :sender_id, :recipient_id, :status, presence: true
  validates :sender_id, uniqueness: { scope: [:recipient_id, :term_id] }

  scope :latest, -> { order(updated_at: :desc) }

  aasm column: :status, whiny_transitions: false do
    state :read
    state :unread

    event :make_read do
      transitions to: :read
    end

    event :make_unread do
      transitions to: :unread
    end
  end

  def self.between(sender_id, recipient_id, term_id)
    where("(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ?)", sender_id, recipient_id, recipient_id, sender_id).where(term_id: term_id).first
  end

  def self.user_conversation(user_id, term_id)
    where('recipient_id = ? OR sender_id = ?', user_id, user_id).where(term_id: term_id)
  end

  def last_message
    messages.last&.body
  end

  def second_user(user)
    if self.recipient_id == user.id
      self.sender
    else
      self.recipient
    end
  end
end
