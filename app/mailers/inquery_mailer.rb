class InqueryMailer < ApplicationMailer
  default from: Settings.common.app.mail.from

  def post_to_operation(user, content)
    @user = User.find user.id
    @content = content

    mail(to: User.operation_user.email,
         subject: "お問い合わせ")
  end
end
