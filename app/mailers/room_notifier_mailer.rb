class RoomNotifierMailer < ApplicationMailer
  include RoomNotifierModule

  default from: Settings.common.app.mail.from

  def notify_new_message(message, user)
    @room = message.room
    @sender = message.user
    @content = message.content
    @url  = room_url(@room.owner.uuid)

    mail(to: user.email,
         subject: "新しいメッセージがあります")
  end
end
