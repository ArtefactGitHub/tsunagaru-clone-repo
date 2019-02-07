class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: %i[destroy]

  def new
    return redirect_to mypage_root_url if current_user.present?

    @user = User.new
  end

  def create
    return redirect_to login_url, danger: 'ログイン出来ません' if login_to_admin?

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

  private

  def login_to_admin?
    user = User.find_by(email: params[:email])
    user.present? && user.admin?
  end
end
