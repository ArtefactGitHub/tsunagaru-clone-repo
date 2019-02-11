module FetchEnvModule
  extend ActiveSupport::Concern

  included do
    def env_can_login?
      ENV.fetch(Settings.env.can_login, 'true') == 'true'
    end

    def env_can_create_user?
      ENV.fetch(Settings.env.can_create_user, 'true') == 'true'
    end
  end
end
