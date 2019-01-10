class Mypage::Friend::RequestsController < ApplicationController
  before_action :require_login, only: %i[index]
  layout 'mypage'

  def new; end
end
