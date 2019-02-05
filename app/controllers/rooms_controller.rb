class RoomsController < ApplicationController
  before_action :require_login
  before_action :set_room, only: %i[show]
  before_action :set_room_by_room_id, only: %i[update_message_button_list]
  before_action :set_message_button_list, only: %i[show update_message_button_list]
  layout 'room'

  def show; end

  def update_message_button_list
    if @message_button_list.update message_button_list_params

      # メッセージボタンリストの更新を実行したユーザーの部屋へ、メッセージを「システム」から飛ばす
      # ユーザーが在室していた場合、ボタンが更新されたことを通知するため
      Message.system_to_room(t('rooms.notify_update_message_button_list'), @room)

      redirect_to room_url(@room), success: 'メッセージボタンを更新しました'
    else
      redirect_to room_url(@room), danger: 'メッセージボタンが更新出来ませんでした'
    end
  end

  private

  def can_access_room
    @room.present? && current_user.can_access_room?(@room)
  end

  def set_room
    set_room_with_symbol :id
  end

  def set_room_by_room_id
    set_room_with_symbol :room_id
  end

  def set_room_with_symbol(id_symbol)
    @room = Room.find_by(id: params[id_symbol])
    return redirect_to mypage_root_path, danger: 'ルームが見つかりません' unless can_access_room

    @messages = @room.messages.page(params[:page])
  end

  def set_message_button_list
    @message_button_list = @room.message_button_list
  end

  def message_button_list_params
    params.require(:message_button_list).permit(message_button: [:message_type, :message_no, :content])
  end
end
