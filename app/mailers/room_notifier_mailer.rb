class RoomNotifierMailer < ApplicationMailer
  include RoomNotifierModule

  default from: Settings.common.app.mail.from

  def notify_new_message(message, users)
    @room = message.room
    @sender = message.user
    @content = message.content
    @url  = room_url(@room.owner.uuid)

    users.each do |u|
      next if u == @sender

      mail(to: u.email,
           subject: "新しいメッセージがあります")
    end
  end
end
