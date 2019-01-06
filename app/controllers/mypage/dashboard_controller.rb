class Mypage::DashboardController < ApplicationController
  before_action :require_login, only: %i[show]

  def show; end
end
