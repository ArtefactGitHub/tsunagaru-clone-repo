class Information < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  validates :display_time, presence: true
  validates :title, presence: true
  # validates :content, presence: true
end
