class MessageCommand < ApplicationRecord
  enum message_type: { ask: 0, answer: 1 }
end
