class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  def index
    @messages = Message.all
  end

  # GET /messages/1
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  def create
    conversation_id = params[:conversation_id].to_i

    if conversation_id < 0
      recipient_id = params[:recipient_id]

      conversation = Conversation.between(current_user.id, recipient_id)
      conversation ||= Conversation.create(sender_id: current_user.id, recipient_id: recipient_id)

      conversation_id = conversation.id
    end

    @message = Message.new(message_params)
    @message.user_id = current_user.id
    @message.conversation_id = conversation_id
    @message.save
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      redirect_to @message, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
    redirect_to messages_url, notice: 'Message was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:body)
    end
end
