class UsersController < ApplicationController
  include CreateUserModule
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
    before_save

    if @user.save
      after_save

      # メンテナンス時、ユーザー登録が行える状況でもログインは行えない
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
