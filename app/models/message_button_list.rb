class MessageButtonList < ApplicationRecord
  has_many :message_buttons, dependent: :destroy

  # リストの更新
  # 想定しているパラメータフォーマット
  #   "message_button"=>{
  #     "0"=>{
  #       "message_type"=>"ask", "message_no"=>"1", "content"=>"今　何してる？"
  #     },
  #     以下、配列の形で"1", "2"と続く
  def update!(params)
    array = params[:message_button].keys.sort.map { |index| params[:message_button][index] }

    array.each do |element|
      msg = message_buttons.where(message_no: element[:message_no])
                           .where(message_type: element[:message_type])
                           .first
      msg.update!(content: element[:content]) if msg.present?
    end
  end

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
