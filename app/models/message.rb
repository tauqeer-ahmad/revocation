class Message < ApplicationRecord
  include AASM

  belongs_to :conversation, touch: true
  belongs_to :user

  validates :body, :status, :conversation_id, presence: true

  scope :secondary, -> (user_id) { where.not(user_id: user_id) }

  after_save do
    conversation.update_attributes(updated_at: Time.now, status: 'unread')
  end

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

  def self.unread_count(user_id, term_id)
    joins(:conversation).where("((conversations.sender_id = ? AND user_id != ?) OR (conversations.recipient_id = ? AND user_id != ?)) AND messages.status = ? AND conversations.term_id = ?", user_id, user_id, user_id, user_id, 'unread', term_id).count
  end
end
