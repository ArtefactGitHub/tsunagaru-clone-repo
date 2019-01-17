class Mypage::Friend::FriendsController < MypageController
  def index
    @friends = FriendRequest.approvals current_user
  end

  # current_user と receiver の双方向関係のレコードを削除する
  def destroy
    @friend = FriendRequest.find(params[:id])
    opponent_user = User.find(@friend.receiver.id)
    own_pair = FriendRequest.approval_own_pair(current_user, opponent_user)
    own_pair.each do |pair|
      pair.destroy!
    end
    redirect_to mypage_friend_friends_url
  end
end
