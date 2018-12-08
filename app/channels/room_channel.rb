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
    Message.create! content: MessageCommand.find(data['command_id']).name
  end

  def all_clear
    Message.destroy_all
  end
end
