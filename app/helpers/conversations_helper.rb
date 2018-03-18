module ConversationsHelper
  def unread_messages_count
    Conversation.user_conversation(current_user.id, current_term.id).map do |conversation|
      conversation.messages.unread.where.not(user_id: current_user.id)
    end.flatten.count
  end
end
