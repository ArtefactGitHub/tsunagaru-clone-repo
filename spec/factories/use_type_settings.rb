FactoryBot.define do
  factory :use_type_setting do
    use_text_input        { true }
    use_button_input      { false }
    use_mail_notification { false }
  end
end
