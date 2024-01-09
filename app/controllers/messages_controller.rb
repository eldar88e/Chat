class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:user_id]
      @user     = User.find_by!(id: params[:user_id])
      @messages = Message.where(
        "((sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)) AND recipient_type = 'User'",
        current_user.id, @user.id, @user.id, current_user.id
      ).order(:created_at)
    elsif params[:room_id]
      @room     = current_user.rooms.find_by!(id: params[:room_id])
      @messages = @room.messages
    end

    respond_to do |format|
      format.turbo_stream { turbo_stream.replace(:messenger, partial: 'messages/messages_block') }
      format.html
    end
  end

  def create
    if params[:room_id]
      @room    = current_user.rooms.find(params[:room_id])
      @message = @room.messages.build(message_params)
    elsif params[:user_id]
      @user    = User.find(params[:user_id])
      @message = @user.messages.build(message_params)
    end

    @message.sender = current_user

    if @message.save
      @message.broadcast_append_to :message, locals: { current_user: current_user }
      head :ok
    end
  end

  private

  def set_room

  end

  def message_params
    params.require(:message).permit(:content)
  end
end
