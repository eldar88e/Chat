class MessagesController < ApplicationController
  before_action :authenticate_user!
  include MessagesHelper

  before_action :ensure_turbo_stream_request, only: [:index]

  def index
    if params[:user_id]
      fetch_user_messages
    elsif params[:room_id]
      fetch_room_messages
    end

    render turbo_stream: turbo_stream.replace(:messenger, partial: 'messages/messages_block')
  end

  def create
    if params[:room_id]
      @room = current_user.rooms.find(params[:room_id])
    elsif params[:user_id]
      @user = User.find(params[:user_id])
    end

    @message = (@room || @user).messages.build(message_params)
    @message.sender = current_user

    if @message.save
      @message.broadcast_append_to(channel, locals: { current_user: current_user })
      head :ok
      send_notice
    else
      error_notice(@message.errors.full_messages)
      head :internal_server_error
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def fetch_user_messages
    @user     = User.find(params[:user_id])
    @messages = Message.between_users(current_user, @user).order(:created_at)
  end

  def fetch_room_messages
    @room     = current_user.rooms.find(params[:room_id])
    @messages = @room.messages
  end

  def ensure_turbo_stream_request
    redirect_to root_path, alert: 'Invalid request format' unless turbo_frame_request?
  end

  def send_notice
    if @message.recipient_type == 'Room'
      memberships = Room.find(@message.recipient_id).memberships
      memberships.each { |membership| send_to_broadcast(membership.user_id) if current_user.id != membership.user_id }
    else
      send_to_broadcast(recipient_id) if recipient_id != current_user.id
    end
  end

  def send_to_broadcast(id)
    Turbo::StreamsChannel.broadcast_append_to(
      "recipient_#{id}",
      target: :notices,
      partial: '/shared/notice',
      locals: { notices: "You've got a message", key: 'success' }
    )
  end
end
