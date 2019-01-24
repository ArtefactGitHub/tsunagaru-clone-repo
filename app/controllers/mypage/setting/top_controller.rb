class Mypage::Setting::TopController < Mypage::SettingController
  def show
    @message_button_list = current_user.my_room.message_button_list
  end
end
