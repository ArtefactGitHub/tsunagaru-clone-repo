class Message < ApplicationRecord
  include RoomNotifierModule

  belongs_to :user
  belongs_to :room

  after_create_commit {
    # deliver_later の場合、update_at_message が先に処理されることがあるため、予め対象を抽出しておく
    users = need_message_notifiers(self.room)
    RoomNotifierMailer.notify_new_message(self, users.to_a).deliver_later

    update_at_message self.room
    MessageBroadcastJob.perform_later self
  }

  default_scope -> { order(created_at: :desc) }

  validates :content, length: { in: 1..100 }
  validates :user_id, presence: true
  validates :room_id, presence: true

  class << self
    def system_to_room(content, room)
      Message.create!(content: content, user: User.system_user, room: room)
    end
  end
end
