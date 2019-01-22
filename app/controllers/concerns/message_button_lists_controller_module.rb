module MessageButtonListsControllerModule
  extend ActiveSupport::Concern

  def setup_default_messages(room)
    list = room.create_message_button_list!

    if list.ask_message_buttons.blank?
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_1'), message_type: :ask, message_no: 1)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_2'), message_type: :ask, message_no: 2)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_3'), message_type: :ask, message_no: 3)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_4'), message_type: :ask, message_no: 4)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_5'), message_type: :ask, message_no: 5)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_ask_6'), message_type: :ask, message_no: 6)
    end

    if list.answer_message_buttons.blank?
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_1'), message_type: :answer, message_no: 1)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_2'), message_type: :answer, message_no: 2)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_3'), message_type: :answer, message_no: 3)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_4'), message_type: :answer, message_no: 4)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_5'), message_type: :answer, message_no: 5)
      list.message_buttons.create!(content: I18n.t('mypage.setting.message_buttons.default_answer_6'), message_type: :answer, message_no: 6)
    end
  end
end
