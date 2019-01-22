class Mypage::Setting::MessageButtonListsController < Mypage::SettingController
  before_action :set_message_button_list, only: %i[show]

  def show
    @ask_message_buttons = @message_button_list.ask_message_buttons
    @answer_message_buttons = @message_button_list.answer_message_buttons
  end

  def update; end

  private

  def set_message_button_list
    @message_button_list = current_user.my_room.message_button_list
  end
end
