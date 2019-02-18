class Message < ApplicationRecord
  include RoomNotifierModule

  belongs_to :user
  belongs_to :room

  after_create_commit {
    # update_at_message の前に通知処理を走らせる（更新時刻が条件に関わるため）
    send_room_notify self

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
