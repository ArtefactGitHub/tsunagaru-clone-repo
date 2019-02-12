class Mypage::Friend::RequestsController < Mypage::FriendController
  include LoggerModule

  def index
    set_new_request_params
  end

  # Create の経路は2パターン
  # 　申請を受けた状態で、それを承認する場合
  # 　　→　uuid が送られてこない、receiver_id が送られてくる
  # 　申請を受けた状態で、その相手に申請した場合
  # 　　→　uuid が送られてくる、receiver_id が送られてこない
  def create
    @request = FriendRequest.new(request_params)
    return show_failure('申請相手が見つかりません') if @request.not_found_reciever?

    @request.setup_for_create(current_user)

    if @request.save
      receiving = FriendRequest.receiving_from(current_user, @request.receiver).first
      if receiving
        @request.update_approval!
        receiving.update_approval!
        redirect_to mypage_friend_requests_path, success: 'トモダチ申請が承認されました'
      else
        redirect_to mypage_friend_requests_path, success: 'トモダチ申請を行いました'
      end
    else
      show_failure 'トモダチ申請が出来ませんでした'
    end
  end

  def destroy
    @request = FriendRequest.find(params[:id])
    opponent_user = User.find(@request.receiver.id)
    opponent_name = opponent_user.name
    own_pair = FriendRequest.pair_bidirectional(current_user, opponent_user)
    own_pair.each do |pair|
      pair.destroy!
    end
    redirect_to mypage_friend_requests_path, success: "#{opponent_name}さんへのトモダチ申請をやめました"
  end

  private

  def request_params
    params.require(:friend_request).permit(:receiver_id, :uuid)
  end

  def show_failure(message)
    flash.now[:danger] = message
    set_new_request_params
    render :index
  end

  def set_new_request_params
    @request ||= FriendRequest.new
    @requests = FriendRequest.sending_receiving current_user
    @friends = User.friends_of current_user
  end
end
