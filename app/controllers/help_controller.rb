class HelpController < ApplicationController
  skip_before_action :require_login
  before_action :check_maintenance, only: %i[show]

  def show; end
end
