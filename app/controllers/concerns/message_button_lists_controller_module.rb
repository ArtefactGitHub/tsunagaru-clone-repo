module MessageButtonListsControllerModule
  extend ActiveSupport::Concern

  def setup_default_messages(room)
    list = room.create_message_button_list!

    if list.ask_message_buttons.blank?
      Settings.setting.message_button.default_count.times { |i|
        list.message_buttons.create!(content: I18n.t("mypage.setting.message_buttons.default_ask_#{i+1}"), message_type: :ask, message_no: (i+1))
      }
    end

    if list.answer_message_buttons.blank?
      Settings.setting.message_button.default_count.times { |i|
        list.message_buttons.create!(content: I18n.t("mypage.setting.message_buttons.default_answer_#{i+1}"), message_type: :answer, message_no: (i+1))
      }
    end
  end
end
