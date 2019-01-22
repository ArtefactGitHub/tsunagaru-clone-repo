class Mypage::Setting::MessageButtonListsController < Mypage::SettingController
  before_action :set_message_button_list, only: %i[show update]

  def show
    @ask_message_buttons = @message_button_list.ask_message_buttons
    @answer_message_buttons = @message_button_list.answer_message_buttons
  end

  def update
    list_params = message_button_list_params
    p 'list_params ============='
    p list_params

    items = list_params[:message_button].keys.sort.map { |index| list_params[:message_button][index] }
    p 'items ============='
    p items

    p 'asks ============='
    asks = []
    items.each do |i|
      p i[:message_type]
      asks << i if i[:message_type] == :ask.to_s
    end
    p asks

    p 'answers ============='
    answers = []
    items.each do |i|
      p i[:message_type]
      answers << i if i[:message_type] == :answer.to_s
    end
    p answers

    p '============='
    asks.each do |ask|
      msg = @message_button_list.message_buttons
                                .where(message_no: ask[:message_no])
                                .where(message_type: :ask)
                                .first
      msg.update!(content: ask[:content]) if msg.present?
    end
    answers.each do |answer|
      msg = @message_button_list.message_buttons
                                .where(message_no: answer[:message_no])
                                .where(message_type: :answer)
                                .first
      msg.update!(content: answer[:content]) if msg.present?
    end

    redirect_to mypage_setting_message_button_list_url, success: '更新しました'
  end

  private

  def set_message_button_list
    @message_button_list = current_user.my_room.message_button_list
  end

  def message_button_list_params
    p '============='
    p params
    params.require(:message_button_list).permit(message_button: [:message_type, :message_no, :content])
  end
end
