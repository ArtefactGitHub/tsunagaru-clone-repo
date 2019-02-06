class UserMailer < ApplicationMailer
  default from: Settings.common.app.mail.from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email
    @user = User.find user.id
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email,
         subject: "パスワードの初期化")
  end
end
