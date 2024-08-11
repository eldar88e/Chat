class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @new_room = Room.new(name: params[:name])

    if @new_room.save
      @memberships = @new_room.memberships.build(user_id: current_user.id)
      if @memberships.save
        render turbo_stream: [turbo_stream.append(:rooms, partial: 'rooms/room', locals: { room: @new_room }),
                              success_notice("#{@new_room.name} room created")
        ]
      else
        error_notice(@memberships.errors.full_messages)
      end
    else
      error_notice(@new_room.errors.full_messages)
    end
  end
end
