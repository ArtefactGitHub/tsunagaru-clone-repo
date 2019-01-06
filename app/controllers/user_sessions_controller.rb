class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: %i[destroy]

  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to mypage_root_url, success: t('user_sessions.flash.create.success')
    else
      flash.now[:danger] = t('user_sessions.flash.create.fail')
      render :new
    end
  end

  def destroy
    logout
    redirect_to login_url, success: t('user_sessions.flash.destroy.success')
  end
end
