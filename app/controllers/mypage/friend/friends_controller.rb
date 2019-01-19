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

    # トモダチ解除を実行したユーザーの部屋へ、メッセージを「システム」から飛ばす
    # 解除されたユーザーが在室していた場合、受信時にストリームの停止が走り、以降のメッセージを受信出来なくするため
    Message.system_to_room('-----', current_user.my_room)

    redirect_to mypage_friend_friends_url
  end
end
