class RoomNotifierMailer < ApplicationMailer
  include RoomNotifierModule

  default from: Settings.common.app.mail.from

  def notify_new_message(message)
    @room = message.room
    @sender = message.user
    @content = message.content
    @url  = room_url(@room)

    users = need_message_notifiers(@room)
    users.each do |u|
      next if u == @sender

      mail(to: u.email,
           subject: "新しいメッセージがあります")
    end
  end
end
