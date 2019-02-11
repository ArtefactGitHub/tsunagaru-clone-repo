class TermController < ApplicationController
  skip_before_action :require_login
  skip_before_action :check_maintenance
end
