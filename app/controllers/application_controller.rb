class ApplicationController < ActionController::Base
  include CheckMaintenanceModule
  protect_from_forgery with: :exception
  before_action :check_maintenance
  before_action :require_login

  add_flash_types :success, :info, :warning, :danger

  def check_maintenance
    redirect_if_maintenance
  end

  private

  def not_authenticated
    redirect_to login_url, danger: 'ログインしてください'
  end
end
