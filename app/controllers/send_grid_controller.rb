class SendGridController < ApplicationController
  layout 'sendgrid'
  skip_before_action :require_login

  def index; end
end
