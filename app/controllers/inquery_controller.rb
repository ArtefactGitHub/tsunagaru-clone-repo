class InqueryController < ApplicationController
  def new; end

  def create
    content = params[:content]
    return redirect_to inquery_url, success: 'お問い合わせを行いました' unless content.present?

    InqueryMailer.post_to_operation(current_user, content).deliver_later
    redirect_to inquery_url, success: 'お問い合わせを行いました'
  end
end
