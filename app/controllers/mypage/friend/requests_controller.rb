class Mypage::Friend::RequestsController < MypageController
  def new
    set_new_request_params
  end

  def create
    @request = FriendRequest.new(request_params)
    @request.sender = current_user
    @request.friend_request_status = :request

    if @request.save
      receiving = FriendRequest.receiving_from(current_user, @request.receiver).first
      if receiving
        @request.update_approval!
        receiving.update_approval!
        redirect_to new_mypage_friend_request_path, success: 'トモダチ申請が承認されました'
      else
        redirect_to new_mypage_friend_request_path, success: 'トモダチ申請を行いました'
      end
    else
      flash.now[:danger] = 'トモダチ申請が出来ませんでした'
      logger.debug @request.errors.full_messages if @request.present?

      set_new_request_params
      render :new
    end
  end

  private

  def request_params
    params.require(:friend_request).permit(:receiver_id)
  end

  def set_new_request_params
    @request = FriendRequest.new
    @requests = FriendRequest.sending_receiving current_user
  end
end
