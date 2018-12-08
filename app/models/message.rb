class Message < ApplicationRecord
  after_create_commit { MessageBroadcastJob.perform_later self }

  default_scope -> { order(created_at: :desc) }

  @@messages = [
    '今　何してる？',
    'ご飯　何食べた？',
    '今　電話できる？',
  ]

  @@error_messages = [
    'エラーです'
  ]

  class << self
    def messages
      @@messages
    end

    def message_by_command_id(command_id)
      return @@error_messages[0] if @@messages.count <= command_id

      @@messages[command_id]
    end
  end
end
