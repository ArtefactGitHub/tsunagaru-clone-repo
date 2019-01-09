class RoomsController < ApplicationController
  before_action :require_login

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages
  end
end
