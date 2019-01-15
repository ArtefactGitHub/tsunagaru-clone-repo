class FriendRequest < ApplicationRecord
  include FriendRequestStatus

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :sender_id, uniqueness: { scope: :receiver_id }
  validate :can_not_request_to_sender
  validate :can_not_request_to_friend

  scope :sending_receiving, ->(current_user) { sending(current_user).or(receiving(current_user)) }
  scope :sending, ->(current_user) { where(sender_id: current_user.id).where.not(friend_request_status: :approval) }
  scope :receiving, ->(current_user) { where(receiver_id: current_user.id).where.not(friend_request_status: :approval) }
  scope :receiving_from, ->(current_user, sender) { receiving(current_user).where(sender_id: sender.id).where.not(friend_request_status: :approval) }
  scope :approvals, ->(current_user) { where(sender_id: current_user.id).where(friend_request_status: :approval) }
  scope :approval_pair, ->(sender, receiver) { where(sender_id: sender.id).where(receiver_id: receiver.id).where(friend_request_status: :approval) }
  scope :approval_own_pair, ->(current_user, opponent_user) { approval_pair(current_user, opponent_user).or(approval_pair(opponent_user, current_user)) }

  def can_not_request_to_sender
    errors.add(:receiver_id, '自分自身にトモダチ申請を送ることは出来ません') if receiver_id == sender_id
  end

  def can_not_request_to_friend
    errors.add(:receiver_id, 'トモダチにトモダチ申請を送ることは出来ません') if FriendRequest.approval_pair(sender, receiver).present?
  end

  def update_approval!
    update!(friend_request_status: :approval)
  end

  def sending?(sender)
    sender_id == sender.id
  end

  def receiving?(sender)
    receiver_id == sender.id
  end
end
