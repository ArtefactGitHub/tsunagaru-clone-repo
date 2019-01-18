class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params['room_id'])
    if current_user.can_access_room?(room)
      stream_from "room_channel_#{params['room_id']}"
    else
      logger.warn "不正な入室：user=#{current_user.id}, room=#{room.id}"
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def speak(data)
    room = Room.find(params['room_id'])
    if current_user.can_access_room?(room)
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
