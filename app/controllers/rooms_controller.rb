class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @new_room = Room.new(name: params[:name])
    if @new_room.save
      @memberships = @new_room.memberships.build(user_id: current_user.id)
      if @memberships&.save
        @new_room.broadcast_append_to :room
        head :ok
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
end
