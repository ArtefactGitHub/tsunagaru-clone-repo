class Mypage::Friend::RequestsController < MypageController
  def new
    @request = FriendRequest.new
  end

  def create
    @request = FriendRequest.new(request_params)
    @request.own = current_user

    if @request.save
      @request = FriendRequest.new
      flash.now[:success] = "トモダチ申請をしました"
      render :new
    else
      flash.now[:danger] = 'トモダチ申請が出来ませんでした'
      render :new
    end
  end

  private

  def request_params
    params.require(:friend_request).permit(:opponent_id)
  end
end
