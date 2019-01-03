class RoomsController < ApplicationController
  before_action :require_login

  def show
    @messages = Message.all
  end
end
