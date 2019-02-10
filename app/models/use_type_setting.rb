class UseTypeSetting < ApplicationRecord
  include UseType

  belongs_to :user

  validates :use_text_input, inclusion: {in: [true, false]}
  validates :use_button_input, inclusion: {in: [true, false]}
  validates :use_mail_notification, inclusion: {in: [true, false]}
  validates :user_id, presence: true

  def setup_optional
    self.use_text_input = self.use_normal?
    self.use_button_input = self.only_chat?
  end

  def use_type_normal?
    use_normal?
  end

  def use_type_only_chat?
    only_chat?
  end

  def use_text_input?
    use_text_input
  end

  def use_button_input?
    use_button_input
  end

  def use_mail_notification?
    use_mail_notification
  end
end
