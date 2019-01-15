class UsersController < ApplicationController
  include RoomsModule

  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.set_uuid
    if @user.save
      create_owner_room @user

      redirect_to login_url, success: t('users.flash.create.success')
    else
      logger.debug @user.errors.full_messages if @user&.errors.present?

      flash.now[:danger] = t('users.flash.create.fail')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
