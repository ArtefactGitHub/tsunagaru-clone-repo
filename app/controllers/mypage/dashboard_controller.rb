class Mypage::DashboardController < ApplicationController
  before_action :require_login, only: %i[show]
  layout 'mypage'

  def show
    @friends = User.friends_of current_user
  end
end
