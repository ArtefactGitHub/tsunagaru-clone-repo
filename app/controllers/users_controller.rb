class UsersController < ApplicationController
  include RoomsControllerModule
  include UseTypeSettingsControllerModule
  include LoggerModule

  skip_before_action :require_login, only: %i[new create]

  def check_maintenance
    redirect_if_maintenance unless env_can_create_user?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.set_uuid
    if @user.save
      create_owner_room @user
      create_use_type_setting @user

      # メンテナンス時、ユーザー登録が行えてもログインは行えない
      return redirect_if_maintenance unless env_can_login?

      # 登録の流れでそのままログインする
      auto_login(@user, params.dig(:remember))
      redirect_back_or_to mypage_root_url, success: 'ログインしました'
    else
      log_debug @user.errors.full_messages if @user&.errors.present?

      flash.now[:danger] = 'ユーザー登録出来ませんでした'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
