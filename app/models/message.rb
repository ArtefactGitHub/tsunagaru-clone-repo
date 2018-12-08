class Message < ApplicationRecord
  after_create_commit { MessageBroadcastJob.perform_later self }

  default_scope -> { order(created_at: :desc) }

  validates :content, length: { in: 1..99 }
end
