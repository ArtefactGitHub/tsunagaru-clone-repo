class Mypage::SettingsController < ApplicationController
  before_action :require_login, only: %i[show]
end
