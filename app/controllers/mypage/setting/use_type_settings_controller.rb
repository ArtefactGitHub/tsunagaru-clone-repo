class Mypage::Setting::UseTypeSettingsController < Mypage::SettingController
  before_action :set_use_type_setting, only: %i[edit update]

  def edit; end

  def update
    if @use_type_setting.update use_type_setting_params
      redirect_to edit_mypage_setting_use_type_setting_url(@use_type_setting), success: '更新しました'
    else
      flash.now[:danger] = '更新出来ませんでした'
      render :edit
    end
  end

  private

  def set_use_type_setting
    @use_type_setting = current_user.use_type_setting
  end

  def use_type_setting_params
    params[:use_type_setting][:use_text_input] = false if params.dig(:use_type_setting, :use_text_input).blank?
    params[:use_type_setting][:use_button_input] = false if params.dig(:use_type_setting, :use_button_input).blank?
    params.require(:use_type_setting).permit(:use_type, :use_text_input, :use_button_input)
  end
end
