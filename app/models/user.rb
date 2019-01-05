class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :messages
  has_one :my_room, class_name: 'Room'
  has_many :rooms, through: :messages

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end
