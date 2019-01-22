class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :users, through: :messages
  has_one :message_button_list, dependent: :destroy

  validates :name, presence: true

  def ask_message_buttons
    message_button_list.ask_message_buttons
  end

  def answer_message_buttons
    message_button_list.answer_message_buttons
  end

  def message_button_by_params(type, no)
    message_button_list.message_button_by_params(type, no)
  end
end
