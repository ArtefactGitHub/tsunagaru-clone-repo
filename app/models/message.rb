class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_create_commit { MessageBroadcastJob.perform_later self }

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
