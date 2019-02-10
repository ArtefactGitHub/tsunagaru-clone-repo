module RoomNotifierModule
  extend ActiveSupport::Concern

  included do
    NOTIFY_INTERVAL = 5.seconds

    has_many :room_notifiers
    # validates :room_notifiers, presence: true

    scope :need_room_notifiers, ->(room, users){
      need_update_room_notifiers(room, users)
      .or(need_create_room_notifiers(room, users))
    }
    scope :need_update_room_notifiers, ->(room, users){
      friends_of(room.owner)
        .where(RoomNotifier.where('room_id = :room_id AND user_id IN (:user_ids)',
                              room_id: room.id,
                              user_ids: users)
                           .where('updated_at > ?', Time.current + Settings.room.notify_interval))
    }
    scope :need_create_room_notifiers, ->(room_id, users){
      friends_of(room.owner)
        .where(RoomNotifier.where('room_id = :room_id AND user_id NOT IN (:user_ids)',
                              room_id: room_id,
                              user_ids: users))
    }
  end
end
