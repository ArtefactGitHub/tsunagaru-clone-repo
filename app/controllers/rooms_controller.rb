class RoomsController < ApplicationController
  before_action :require_login
  layout 'room'

  def show
    @room = Room.find(params[:id])
    return @messages = [] unless @room.meet_the_requirements?(current_user)

    @messages = @room.messages
  end
end
