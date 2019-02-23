class Admin::UserSessionsController < AdminController
  skip_before_action :require_login, except: %i[destroy]
  skip_before_action :check_maintenance
  skip_before_action :require_admin

  def new
    @user = User.new
  end

  def create
    return redirect_to login_url, danger: 'ログイン出来ません' unless login_to_admin_with_email? params[:email]

    @user = login(params[:email], params[:password], params[:remember])
    if @user
      redirect_to admin_root_url, success: 'ログインしました'
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
