class AboutController < ApplicationController
  include ApplicationHelper
  skip_before_action :require_login
  before_action :check_maintenance, only: %i[show]

  def show
    return redirect_to mypage_root_url if logged_in? && env_can_login?
  end

  def show_about
    render :show
  end
end
