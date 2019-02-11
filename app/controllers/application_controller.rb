class ApplicationController < ActionController::Base
  include CheckMaintenanceModule
  protect_from_forgery with: :exception
  before_action :check_maintenance
  before_action :require_login

  add_flash_types :success, :info, :warning, :danger

  # メンテナンス判定（heroku のメンテナンスモードだと管理者ログインが行えないため）
  # UserSessionsController では個別の判定を行なっている（管理者ログインを行うため）
  # UsersController では個別の判定を行なっている（デフォルトではメンテナンス中もユーザー作成は行えるため）
  def check_maintenance
    return redirect_if_maintenance unless env_can_login?
  end

  private

  def not_authenticated
    redirect_to login_url, danger: 'ログインしてください'
  end
end
