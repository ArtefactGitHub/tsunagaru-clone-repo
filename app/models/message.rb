class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_create_commit { MessageBroadcastJob.perform_later self }

  default_scope -> { order(created_at: :desc) }

  validates :content, length: { in: 1..99 }
  validates :user_id, presence: true
  validates :room_id, presence: true
end
