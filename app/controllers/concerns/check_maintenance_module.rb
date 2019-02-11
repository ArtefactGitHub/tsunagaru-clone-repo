module CheckMaintenanceModule
  include FetchEnvModule

  extend ActiveSupport::Concern

  included do
    def redirect_if_maintenance
      return true if current_user&.admin?

      return redirect_to about_url, danger: 'メンテナンス中のため、しばらくお待ちください' unless env_can_login?
    end

    def redirect_if_maintenance_on_login
      return redirect_to about_url, danger: 'メンテナンス中のため、しばらくお待ちください'
    end

    def can_login_with_email?(email)
      return true if login_to_admin_with_email? email

      env_can_login?
    end

    def login_to_admin_with_email?(email)
      user = User.find_by(email: email)
      user.present? && user.admin?
    end
  end
end
