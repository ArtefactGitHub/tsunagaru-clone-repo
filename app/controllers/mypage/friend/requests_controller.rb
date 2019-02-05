class Mypage::Friend::RequestsController < Mypage::FriendController
  include LoggerModule

  def index
    set_new_request_params
  end

  def create
    @request = FriendRequest.new(request_params)
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
      flash.now[:danger] = 'トモダチ申請が出来ませんでした'
      log_debug @request.errors.full_messages if @request.present?

      set_new_request_params
      render :index
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

  def set_new_request_params
    @request = FriendRequest.new
    @requests = FriendRequest.sending_receiving current_user
    @friends = User.friends_of current_user
  end
end
