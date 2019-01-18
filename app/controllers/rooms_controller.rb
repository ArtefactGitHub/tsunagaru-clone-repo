class RoomsController < ApplicationController
  before_action :require_login
  layout 'room'

  def show
    @room = Room.find_by(id: params[:id])
    return redirect_to mypage_root_path, danger: 'ルームが見つかりません' unless can_access_room

    @messages = @room.messages
  end

  private

  def can_access_room
    @room.present? && current_user.can_access_room?(@room)
  end
end
