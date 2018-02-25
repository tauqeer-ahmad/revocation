class ConversationsController < ApplicationController
  def index
    @conversations = Conversation.user_conversation(current_user.id, current_term.id).includes(:sender).latest

    @conversation = if params[:conversation_id].present?
      Conversation.find(params[:conversation_id])
    else
      @conversations.first
    end

    if @conversation.present?
      @messages = @conversation.messages.includes(:user).order(:created_at)

      @conversation.update_column(:status, 'read')
      @messages.secondary(current_user.id).update_all(status: 'read') if @messages.present?
    end
  end

  def fetch
    @conversation = Conversation.find(params[:conversation_id])
    @messages = @conversation.messages.includes(:user)

    @conversation.update_column(:status, 'read')
    @messages.secondary(current_user.id).update_all(status: 'read')
  end
end
