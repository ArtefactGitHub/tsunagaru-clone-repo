class User < ApplicationRecord
  require 'securerandom'
  require 'open-uri'

  include Role
  include Rails.application.routes.url_helpers
  include AvatarInfo
  include LoggerModule

  authenticates_with_sorcery!

  attr_accessor :profile_image_url

  has_many :authentications, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :my_room, class_name: 'Room', foreign_key: 'owner_id', dependent: :destroy
  has_many :rooms, through: :messages
  has_many :send_requests, class_name: 'FriendRequest', foreign_key: 'sender_id', dependent: :destroy
  has_many :receive_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id', dependent: :destroy
  has_many :receivers, through: :send_requests, source: :receiver
  has_many :senders, through: :receive_requests, source: :sender
  has_one :use_type_setting, dependent: :destroy
  mount_uploader :image, ImageUploader

  accepts_nested_attributes_for :authentications

  delegate :get_use_type, to: :use_type_setting, allow_nil: false
  delegate :use_type_normal?, to: :use_type_setting, allow_nil: false
  delegate :use_type_only_chat?, to: :use_type_setting, allow_nil: false
  delegate :use_text_input?, to: :use_type_setting, allow_nil: false
  delegate :use_button_input?, to: :use_type_setting, allow_nil: false

  validates :name, presence: true, length: { maximum: 20 }
  validates :introduction, length: { maximum: 999 }
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :uuid, presence: true

  scope :friends_of, ->(user){ where(id: user.send_requests.where(friend_request_status: :approval).pluck(:receiver_id)) }
  scope :room_members_of, ->(room){ friends_of(room.owner).or(where(id: room.owner)) }

  class << self
    def system_user
      User.find_by(email: Rails.application.credentials.dig(:user, :admin, :email_system))
    end

    def operation_user
      User.find_by(email: Rails.application.credentials.dig(:user, :admin, :email_operation))
    end
  end

  def avatar_validation(params)
    return true if params.dig(:image).blank?

    size = params.dig(:image).size
    content_type = params.dig(:image).content_type

    if size > LIMIT_FILE_SIZE
      log_debug("size[#{size}] > LIMIT_FILE_SIZE[#{LIMIT_FILE_SIZE}]")
      # avatar.detach
      errors[:image] << "は #{ActiveSupport::NumberHelper.number_to_human_size(LIMIT_FILE_SIZE)} 以下のサイズにしてください"
    elsif content_type.blank? || !content_type.starts_with?('image/')
      log_debug("!avatar.blob.content_type.starts_with?('image/')")
      # avatar.detach
      errors[:image] << 'のフォーマットが正しくありません'
    else
      return true
    end

    false
  end

  def avatar_or_default
    # avatar.attached? ? rails_blob_url(avatar, only_path: true) : Settings.user.avatar.default_file_name
    # # avatar.attached? ? rails_representation_url(avatar.variant(resize: "500"), only_path: true) : Settings.user.avatar.default_file_name

    image.present? ? image.thumb.url : Settings.user.avatar.default_file_name
  end

  def set_uuid
    # self.uuid = SecureRandom.urlsafe_base64(6)
    self.uuid = calc_urlsafe_base64
  end

  def calc_urlsafe_base64
    length = Settings.user.uuid_urlsafe_base64_length
    result = SecureRandom.urlsafe_base64(length)

    # 1やlなどの似た文字を除いて生成する（最大10回）
    10.times do
      result = SecureRandom.urlsafe_base64(length)
                           .delete(Settings.user.uuid_urlsafe_base64_except)[0,length]
      if result.size == length
        break
      end
    end

    result
  end

  def can_access_room?(room)
    room.owner == self ||
    FriendRequest.approval_own_pair(self, room.owner).present?
  end

  def has_request?
    self.receive_requests.where.not(friend_request_status: :approval).present?
  end

  def can_post_to_operation?
    return true if post_to_operation_sent_at.blank?
    (post_to_operation_sent_at + Settings.user.post_to_operation_interval) < Time.current
  end

  def update_post_to_operation!
    update!(post_to_operation_sent_at: Time.current)
  end

  def assign_password
    pass = SecureRandom.base64(Settings.twitter.auto_fill_password_count)
    assign_attributes(password: pass, password_confirmation: pass)
  end

  def download_and_attach_avatar
    p '==============='
    p "profile_image_url: #{profile_image_url}"
    return unless sns_avatar_image_url

    # ActiveStorage を使う場合
    # file = open(sns_avatar_image_url)
    # avatar.attach(io: file,
    #               filename: "#{Settings.common.avatar.by_sns_file_name}.#{file.content_type_parse.first.split("/").last}",
    #               content_type: file.content_type_parse.first)

    # carrierwave を使う場合
    # remote_profile_image_url = "https://graph.facebook.com/#{facebook_id}/picture?type=large"
    p "sns_avatar_image_url: #{sns_avatar_image_url}"
    self.remote_profile_image_url = sns_avatar_image_url
  end

  def sns_avatar_image_url
    profile_image_url&.gsub(/_normal/, '')
  end
end
