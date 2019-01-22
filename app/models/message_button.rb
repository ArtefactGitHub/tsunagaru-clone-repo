class MessageButton < ApplicationRecord
  belongs_to :message_button_list

  enum message_type: { ask: 0, answer: 1 }
end
