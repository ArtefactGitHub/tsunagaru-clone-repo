class UseTypeSetting < ApplicationRecord
  include UseType

  belongs_to :user

  validates :use_text_input, inclusion: {in: [true, false]}
  validates :use_button_input, inclusion: {in: [true, false]}
  validates :user_id, presence: true

  def setup_optional
    self.use_text_input = self.use_normal?
    self.use_button_input = self.only_chat?
  end
end
