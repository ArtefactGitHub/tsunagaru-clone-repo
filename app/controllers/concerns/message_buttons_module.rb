module MessageButtonsModule
  extend ActiveSupport::Concern

  def setup_default_messages(room)
    if room.ask_message_buttons.blank?
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_1'), message_type: :ask, message_no: 1, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_2'), message_type: :ask, message_no: 2, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_3'), message_type: :ask, message_no: 3, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_4'), message_type: :ask, message_no: 4, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_5'), message_type: :ask, message_no: 5, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_6'), message_type: :ask, message_no: 6, room: room)
    end

    if room.answer_message_buttons.blank?
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_1'), message_type: :answer, message_no: 1, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_2'), message_type: :answer, message_no: 2, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_3'), message_type: :answer, message_no: 3, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_4'), message_type: :answer, message_no: 4, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_5'), message_type: :answer, message_no: 5, room: room)
      MessageButton.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_6'), message_type: :answer, message_no: 6, room: room)
    end
  end
end
