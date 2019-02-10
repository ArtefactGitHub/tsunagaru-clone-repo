class RoomNotifierMailer < ApplicationMailer
  include RoomNotifierModule

  default from: Settings.common.app.mail.from

  def notify_new_message(message)
    @room = message.room
    @sender = message.user
    @content = message.content
    @url  = room_url(@room)

    users = need_message_notifiers(@room)
    p '>>>>>>>>'
    p users.count
    users.each do |u|
      p "user_id: #{u.id}"
      p "name: #{u.name}"
      mail(to: u.email,
           subject: "新しいメッセージがあります") if u != @sender
    end
    p '<<<<<<<<'
  end
end
