class User < ApplicationRecord
  require 'securerandom'

  authenticates_with_sorcery!

  has_many :messages
  has_one :my_room, class_name: 'Room', foreign_key: 'owner_id'
  has_many :rooms, through: :messages
  has_many :send_requests, class_name: 'FriendRequest', foreign_key: 'sender_id'
  has_many :receive_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id'
  has_many :receivers, through: :send_requests, source: :receiver
  has_many :senders, through: :receive_requests, source: :sender

  has_one_attached :avatar

  validates :name, presence: true
  validates :introduction, length: { maximum: 999 }
  validates :email, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :uuid, presence: true

  def avatar_or_default
    avatar.attached? ? avatar : Settings.user.avatar.default_file_name
  end

  def set_uuid
    self.uuid = SecureRandom.urlsafe_base64(6)
  end
end
