class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params['room_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    room = Room.find(params['room_id'])
    if room.meet_the_requirements?(current_user)
      Message.create!(content: data['message'], user: current_user, room: room)
    else
      logger.warn "不正なメッセージ：content=#{data['message']}, user=#{current_user.id}, room=#{room.id}"
    end
  end

  def msg_command(data)
    Message.create!(content: MessageCommand.find(data['command_id']).name,
                    user: current_user,
                    room: Room.find(params['room_id']))
  end

  def all_clear
    Message.destroy_all
  end
end
