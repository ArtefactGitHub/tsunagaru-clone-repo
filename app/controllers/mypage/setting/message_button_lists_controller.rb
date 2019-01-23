class Mypage::Setting::MessageButtonListsController < Mypage::SettingController
  before_action :set_message_button_list, only: %i[show update]

  def show; end

  def update
    if @message_button_list.update message_button_list_params
      # メッセージボタンリストの更新を実行したユーザーの部屋へ、メッセージを「システム」から飛ばす
      # ユーザーが在室していた場合、ボタンが更新されたことを通知するため
      Message.system_to_room(t('rooms.notify_update_message_button_list'), current_user.my_room)

      redirect_to mypage_setting_message_button_list_url, success: '更新しました'
    else
      flash.now[:danger] = '更新出来ませんでした'
      render :show
    end
  end

  private

  def set_message_button_list
    @message_button_list ||= current_user.my_room.message_button_list
  end

  def message_button_list_params
    params.require(:message_button_list).permit(message_button: [:message_type, :message_no, :content])
  end
end
