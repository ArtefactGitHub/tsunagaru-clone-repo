class Mypage::Setting::MessageButtonsController < Mypage::SettingController
  before_action :set_message_buttons_params, only: %i[update]

  def index
    @ask_message_buttons = current_user.my_room.ask_message_buttons
    @answer_message_buttons = current_user.my_room.answer_message_buttons
  end

  def update
  end

  private

  def set_message_buttons_params
    # params.require(:)
  end
end
