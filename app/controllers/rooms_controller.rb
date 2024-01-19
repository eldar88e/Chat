class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @new_room = Room.new(name: params[:name])

    if @new_room.save
      @memberships = @new_room.memberships.build(user_id: current_user.id)
      if @memberships.save
        render turbo_stream: turbo_stream.append(:rooms, partial: 'rooms/room', locals: { room: @new_room })
      end
    else
      redirect_to root_path, alert: 'Error saving room!'
    end
  end
end
