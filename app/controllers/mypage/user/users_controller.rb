class Mypage::User::UsersController < Mypage::UserController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to edit_mypage_user_user_path(current_user), success: 'プロフィールを更新しました'
    else
      # flash.now[:danger] = 'プロフィールを更新出来ませんでした'
      # render :edit
      redirect_to edit_mypage_user_user_path(current_user), danger: 'プロフィールを更新出来ませんでした'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :avatar)
  end
end
