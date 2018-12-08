class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create! content: data['message']
  end

  def msg_command(data)
    messages = ['', '今、何してる？']
    Message.create! content: messages[data['command_id']]
  end

  def all_clear
    Message.destroy_all
  end
end
