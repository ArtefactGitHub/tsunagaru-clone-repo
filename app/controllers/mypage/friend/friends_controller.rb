class Mypage::Friend::FriendsController < MypageController
  def index
    @friends = FriendRequest.approvals current_user
  end
end
