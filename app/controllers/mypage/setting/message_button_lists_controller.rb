class Mypage::Setting::MessageButtonListsController < Mypage::SettingController
  before_action :set_message_button_list, only: %i[show update]

  def show
    @ask_message_buttons = @message_button_list.ask_message_buttons
    @answer_message_buttons = @message_button_list.answer_message_buttons
  end

  def update
    list_params = message_button_list_params
    items = list_params[:message_button].keys.sort.map { |index| list_params[:message_button][index] }

    items.each do |item|
      msg = @message_button_list.message_buttons
                                .where(message_no: item[:message_no])
                                .where(message_type: item[:message_type])
                                .first
      msg.update!(content: item[:content]) if msg.present?
    end

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
