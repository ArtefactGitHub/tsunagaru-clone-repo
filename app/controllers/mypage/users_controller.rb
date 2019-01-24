class Mypage::UsersController < MypageController
  before_action :set_user, only: %i[update]

  def update
    if @user.update(user_params)
      redirect_to mypage_root_path, success: 'プロフィールを更新しました'
    else
      # flash.now[:danger] = 'プロフィールを更新出来ませんでした'
      # render :edit
      redirect_to mypage_root_path, danger: 'プロフィールを更新出来ませんでした'
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
