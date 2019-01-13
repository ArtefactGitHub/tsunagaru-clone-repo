class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :messages
  has_one :my_room, class_name: 'Room', foreign_key: 'owner_id'
  has_many :rooms, through: :messages
  has_one :send_request, class_name: 'FriendRequest', foreign_key: 'sender_id'
  has_one :receive_request, class_name: 'FriendRequest', foreign_key: 'receiver_id'
  has_one_attached :avatar

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  def avatar_or_default
    avatar.attached? ? avatar : Settings.user.avatar.default_file_name
  end
end
