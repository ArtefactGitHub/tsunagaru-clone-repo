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

  def received
    room = Room.find(params['room_id'])
    unless current_user.can_access_room?(room)
      logger.warn "不正な受信：user=#{current_user.id}, room=#{room.id}"
      reject
      stop_all_streams
    end
  end

  def speak(data)
    room = Room.find(params['room_id'])
    if current_user.can_access_room?(room)
      Message.create!(content: data['message'], user: current_user, room: room)
    else
      logger.warn "不正なメッセージ：content=#{data['message']}, user=#{current_user.id}, room=#{room.id}"
      reject
      stop_all_streams
    end
  end

  def speak_by_message_button(data)
    room = Room.find(params['room_id'])
    if current_user.can_access_room?(room)
      mssage_button = room.message_button_by_params(data['message_type'], data['message_no'])
      Message.create!(content: mssage_button.content, user: current_user, room: room) if mssage_button.present?
    else
      logger.warn "不正なメッセージボタン：user=#{current_user.id}, room=#{room.id}"
      reject
      stop_all_streams
    end
  end

  def all_clear
    Message.destroy_all
  end
end
