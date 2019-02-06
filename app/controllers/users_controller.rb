class UsersController < ApplicationController
  include RoomsControllerModule
  include UseTypeSettingsControllerModule
  include LoggerModule

  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.set_uuid
    if @user.save
      create_owner_room @user
      create_use_type_setting @user

      # 登録の流れでそのままログインする
      auto_login(@user)
      redirect_back_or_to mypage_root_url, success: 'ログインしました'
    else
      log_debug @user.errors.full_messages if @user&.errors.present?

      flash.now[:danger] = 'ユーザー登録出来ませんでした'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember)
  end
end
