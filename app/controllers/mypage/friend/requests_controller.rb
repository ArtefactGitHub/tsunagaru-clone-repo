class Mypage::Friend::RequestsController < MypageController
  def new
    @request = FriendRequest.new
    @requests = FriendRequest.sending_receiving current_user
  end

  def create
    @request = FriendRequest.new(request_params)
    @request.own = current_user

    if @request.save
      redirect_to new_mypage_friend_request_path, success: 'トモダチ申請をしました'
    else
      flash.now[:danger] = 'トモダチ申請が出来ませんでした'
      set_new_request_params
      render :new
    end
  end

  private

  def request_params
    params.require(:friend_request).permit(:opponent_id)
  end

  def set_new_request_params
    @request = FriendRequest.new
    @requests = FriendRequest.sending current_user
  end
end
