class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_maintenance
  before_action :require_login

  add_flash_types :success, :info, :warning, :danger

  def check_maintenance
    return true if current_user&.admin?

    return redirect_to about_url, danger: 'メンテナンス中のため、しばらくお待ちください' unless env_can_login?
  end

  def env_can_login?
    ENV.fetch(Settings.env.can_login, 'true') == 'true'
  end

  private

  def not_authenticated
    redirect_to login_url, danger: 'ログインしてください'
  end
end
