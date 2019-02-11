module CheckMaintenanceModule
  include FetchEnvModule

  extend ActiveSupport::Concern

  included do
    def redirect_if_maintenance
      return if current_user&.admin?

      return redirect_to_about
    end

    # ログイン時は current_user が存在しないため、redirect_if_maintenance とは別で判定を行う
    # （ `unless can_login_with_email(email)` の場合にリダイレクトさせる）
    def redirect_if_maintenance_on_login
      return redirect_to_about
    end

    def can_login_with_email?(email)
      return true if login_to_admin_with_email? email

      env_can_login?
    end

    def redirect_to_about
      return redirect_to about_url, danger: 'メンテナンス中のため、しばらくお待ちください'
    end

    def login_to_admin_with_email?(email)
      user = User.find_by(email: email)
      user.present? && user.admin?
    end
  end
end
