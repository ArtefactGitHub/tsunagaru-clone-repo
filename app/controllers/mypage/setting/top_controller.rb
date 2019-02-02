class Mypage::Setting::TopController < Mypage::SettingController
  def show
    @message_button_list = current_user.my_room.message_button_list
    @use_type_setting = current_user.use_type_setting
  end
end
