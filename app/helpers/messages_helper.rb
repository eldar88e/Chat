module MessagesHelper
  def channel
    if @user
      "#{@user.class}_#{[current_user.id, @user.id].sort.join('_')}"
    else
      "#{@room.class}_#{@room.id}"
    end + '_message'
  end
end
