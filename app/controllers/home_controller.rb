class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @rooms = current_user.rooms
  end
end
