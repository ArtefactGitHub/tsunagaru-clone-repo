class Mypage::DashboardController < ApplicationController
  before_action :require_login, only: %i[show]
  layout 'mypage'

  def show
    @friends = FriendRequest.approvals current_user
  end
end
