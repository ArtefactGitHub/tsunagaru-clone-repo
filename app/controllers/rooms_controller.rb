class RoomsController < ApplicationController
  before_action :require_login
  before_action :set_room, only: %i[show]
  before_action :set_room_by_room_id, only: %i[update_message_button_list]
  before_action :set_message_button_list, only: %i[show update_message_button_list]
  layout 'room'

  def show; end

  def update_message_button_list
    @message_button_list.update! message_button_list_params

    # メッセージボタンリストの更新を実行したユーザーの部屋へ、メッセージを「システム」から飛ばす
    # ユーザーが在室していた場合、ボタンが更新されたことを通知するため
    Message.system_to_room(t('rooms.notify_update_message_button_list'), @room)

    redirect_to room_url(@room), success: '更新しました'
  end

  private

  def can_access_room
    @room.present? && current_user.can_access_room?(@room)
  end

  def set_room
    @room = Room.find_by(id: params[:id])
    return redirect_to mypage_root_path, danger: 'ルームが見つかりません' unless can_access_room

    @messages = @room.messages
  end

  def set_room_by_room_id
    @room = Room.find_by(id: params[:room_id])
    return redirect_to mypage_root_path, danger: 'ルームが見つかりません' unless can_access_room
  end

  def set_message_button_list
    @message_button_list = @room.message_button_list
  end

  def message_button_list_params
    params.require(:message_button_list).permit(message_button: [:message_type, :message_no, :content])
  end
end
