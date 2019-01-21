class MessageButton < ApplicationRecord
  belongs_to :room

  enum message_type: { ask: 0, answer: 1 }

  validates :room_id, presence: true
end
