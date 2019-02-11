class UserSessionsController < ApplicationController
  before_action :require_login, only: %i[destroy]
  skip_before_action :check_maintenance, only: %i[new create destroy]

  def new
    @user = User.new
  end

  def create
    return redirect_if_maintenance_on_login unless can_login_with_email? params[:email]

    @user = login(params[:email], params[:password], params[:remember])
    if @user
      redirect_back_or_to mypage_root_url, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログイン出来ません'
      render :new
    end
  end

  def destroy
    remember_me!
    forget_me!
    logout
    redirect_to login_url, success: 'ログアウトしました'
  end
end
