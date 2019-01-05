class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :users, through: :messages

  validates :name, presence: true
end
