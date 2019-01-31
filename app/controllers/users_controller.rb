class UsersController < ApplicationController
  include RoomsControllerModule
  include UseTypeSettingsControllerModule

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

      redirect_to login_url, success: 'ユーザー登録しました'
    else
      logger.debug @user.errors.full_messages if @user&.errors.present?

      flash.now[:danger] = 'ユーザー登録出来ませんでした'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
