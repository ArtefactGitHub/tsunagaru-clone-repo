class Mypage::Friend::FriendsController < ApplicationController
  before_action :require_login, only: %i[index]
  layout 'mypage'

  def index; end
end
