class Mypage::DashboardController < MypageController
  def show
    @friends = User.friends_of current_user
  end
end
