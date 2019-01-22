class MessageButtonList < ApplicationRecord
  has_many :message_buttons, dependent: :destroy

  def ask_message_buttons
    message_buttons.where(message_type: :ask).take(Settings.setting.message_button.default_count)
  end

  def answer_message_buttons
    message_buttons.where(message_type: :answer).take(Settings.setting.message_button.default_count)
  end

  def message_button_by_params(type, no)
    mssage_buttons = type == :ask.to_s ? ask_message_buttons : answer_message_buttons
    mssage_buttons.select { |m| m.message_no == no }.first
  end
end
