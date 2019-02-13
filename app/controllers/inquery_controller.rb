class InqueryController < ApplicationController
  def new; end

  def create
    content = params[:content]
    return redirect_to inquery_url, success: 'お問い合わせを行いました' unless content.present?

    if current_user.can_post_to_operation?
      InqueryMailer.post_to_operation(current_user, content).deliver_later
      current_user.update_post_to_operation!
      redirect_to inquery_url, success: 'お問い合わせを行いました'
    else
      flash.now[:danger] = 'お問い合わせが行えませんでした。お手数ですがしばらくしてお試しください。'
      render :new
    end
  end
end
