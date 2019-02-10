module RoomNotifierModule
  extend ActiveSupport::Concern

  included do
    NOTIFY_INTERVAL = 5.seconds
    # NOTIFY_INTERVAL = 10.minutes

    def update_at_message(room)
      room.update(updated_at_message: Time.current)
    end

    # ルームの新着メッセージ通知が必要なユーザーの取得
    # ルームの「最終メッセージ日時」とユーザーの通知設定（全ルーム）だけで判定する
    def need_message_notifiers(room)
      if room.updated_at_message.blank? || (room.updated_at_message + NOTIFY_INTERVAL) < Time.current + NOTIFY_INTERVAL
        User.friends_of(room.owner)
          .joins(:use_type_setting)
            .where(use_type_settings: { use_mail_notification: true })
      else
        []
      end
    end

    #
    # 未検証：ルームとユーザー毎に通知を判定する場合のスコープ（通知設定の判定は未実装）
    #
    # included do
    #   NOTIFY_INTERVAL = 10.minutes
    #
    #   has_many :room_notifiers
    #   validates :room_notifiers, presence: true
    # end
    #
    # scope :need_room_notifiers, ->(room, users){
    #   need_update_room_notifiers(room, users)
    #   .or(need_create_room_notifiers(room, users))
    # }
    # scope :need_update_room_notifiers, ->(room, users){
    #   friends_of(room.owner)
    #     .where(RoomNotifier.where('room_id = :room_id AND user_id IN (:user_ids)',
    #                           room_id: room.id,
    #                           user_ids: users)
    #                        .where('updated_at > ?', Time.current + Settings.room.notify_interval))
    # }
    # scope :need_create_room_notifiers, ->(room_id, users){
    #   friends_of(room.owner)
    #     .where(RoomNotifier.where('room_id = :room_id AND user_id NOT IN (:user_ids)',
    #                           room_id: room_id,
    #                           user_ids: users))
    # }
  end
end
