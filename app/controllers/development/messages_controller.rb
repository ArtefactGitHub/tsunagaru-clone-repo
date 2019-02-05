class Development::MessagesController < ActionController::Base
  include LoggerModule

  before_action :require_login

  def clear_messages
    unless current_user.admin?
      log_warning "不正なメッセージ削除：user=#{current_user.id}"
      return redirect_to root_url
    end

    Message.destroy_all

    log_debug 'メッセージを全て削除しました'
    redirect_to mypage_root_url, success: "メッセージを全て削除しました"
  end
end
