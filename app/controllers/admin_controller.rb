class AdminController < ApplicationController
  before_action :require_admin

  layout 'application'

  private

  def require_admin
    return if current_user&.admin?

    # return redirect_to about_url, danger: 'メンテナンス中のため、しばらくお待ちください'
    raise ActionController::RoutingError, 'Not Found'
    rescue ActionController::RoutingError
      render file: "#{Rails.root}/public/404", layout: false, status: :not_found
  end
end
