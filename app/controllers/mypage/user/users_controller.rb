class Mypage::User::UsersController < Mypage::UserController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.avatar_validation(user_params) && @user.update(user_params)
      redirect_to mypage_user_path, success: 'プロフィールを更新しました'
    else
      flash.now[:danger] = 'プロフィールを更新出来ませんでした'
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :image, :image_cache, :remove_image)
  end
end
