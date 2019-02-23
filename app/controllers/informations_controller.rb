class InformationsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :check_maintenance

  def index
    @infos = Information.all
  end
end
