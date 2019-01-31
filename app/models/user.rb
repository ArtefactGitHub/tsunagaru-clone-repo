class User < ApplicationRecord
  require 'securerandom'

  include Role
  include Rails.application.routes.url_helpers

  authenticates_with_sorcery!

  has_many :messages, dependent: :destroy
  has_one :my_room, class_name: 'Room', foreign_key: 'owner_id', dependent: :destroy
  has_many :rooms, through: :messages
  has_many :send_requests, class_name: 'FriendRequest', foreign_key: 'sender_id', dependent: :destroy
  has_many :receive_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id', dependent: :destroy
  has_many :receivers, through: :send_requests, source: :receiver
  has_many :senders, through: :receive_requests, source: :sender
  has_one :use_type_setting, dependent: :destroy

  has_one_attached :avatar

  validates :name, presence: true
  validates :introduction, length: { maximum: 999 }
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :uuid, presence: true

  scope :friends_of, ->(user){ where(id: user.send_requests.where(friend_request_status: :approval).pluck(:receiver_id)) }

  class << self
    def system_user
      User.find_by(email: Rails.application.credentials.dig(:user, :admin, :email_system))
    end

    def operation_user
      User.find_by(email: Rails.application.credentials.dig(:user, :admin, :email_operation))
    end
  end

  def avatar_or_default
    avatar.attached? ? rails_blob_url(avatar, only_path: true) : Settings.user.avatar.default_file_name
  end

  def set_uuid
    self.uuid = SecureRandom.urlsafe_base64(6)
  end

  def can_access_room?(room)
    room.owner == self ||
    FriendRequest.approval_own_pair(self, room.owner).present?
  end

  def has_request?
    self.receive_requests.where.not(friend_request_status: :approval).present?
  end
end
