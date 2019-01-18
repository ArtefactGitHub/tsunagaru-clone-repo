class RoomsController < ApplicationController
  before_action :require_login
  layout 'room'

  def show
    @room = Room.find(params[:id])
    return @messages = [] unless current_user.can_access_room?(@room)

    @messages = @room.messages
  end
end
