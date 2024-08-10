class MessagesController < ApplicationController
  before_action :authenticate_user!
  include MessagesHelper

  def index
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      return redirect_to root_path if @user.nil?

      @messages = Message.where(
        "((sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)) AND recipient_type = 'User'",
        current_user.id, @user.id, @user.id, current_user.id
      ).order(:created_at)
    elsif params[:room_id]
      @room = current_user.rooms.find_by(id: params[:room_id])
      return redirect_to root_path if @room.nil?

      @messages = @room.messages
    end

    render turbo_stream: turbo_stream.replace(:messenger, partial: 'messages/messages_block')
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
      @message.broadcast_append_to(channel, locals: { current_user: current_user })
      head :ok
    else
      render json: { error: 'Internal server error while saving data.' }, status: :internal_server_error
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
