class Mypage::Setting::MessageButtonListsController < Mypage::SettingController
  before_action :set_message_button_list, only: %i[show update]

  def show; end

  def update
    @message_button_list.update! message_button_list_params
    redirect_to mypage_setting_message_button_list_url, success: '更新しました'
  end

  private

  def set_message_button_list
    @message_button_list = current_user.my_room.message_button_list
  end

  def message_button_list_params
    params.require(:message_button_list).permit(message_button: [:message_type, :message_no, :content])
  end
end
