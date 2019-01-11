class FriendRequest < ApplicationRecord
  include FriendRequestStatus

  belongs_to :own, class_name: 'User'
  belongs_to :opponent, class_name: 'User'

  validates :own_id, presence: true
  validates :opponent_id, presence: true
  validates :own_id, uniqueness: { scope: :opponent_id }
  validate :can_not_request_to_own
  validate :can_not_request_to_friend

  scope :sending_receiving, ->(own) { sending(own).or(receiving(own)) }
  scope :sending, ->(own) { where(own_id: own.id).where.not(friend_request_status: :approval) }
  scope :receiving, ->(own) { where(opponent_id: own.id).where.not(friend_request_status: :approval) }
  scope :receiving_from, ->(own, opponent) { receiving(own).where(own_id: opponent.id).where.not(friend_request_status: :approval).first }
  scope :approvals, ->(own) { where(own_id: own.id).where(friend_request_status: :approval) }
  scope :approval_to_by_id, ->(own_id, opponent_id) { where(own_id: own_id).where(opponent_id: opponent_id).where(friend_request_status: :approval) }

  def can_not_request_to_own
    if opponent_id == own_id
      errors.add(:opponent_id, '自分自身にトモダチ申請を送ることは出来ません')
    end
  end

  def can_not_request_to_friend
    if FriendRequest.approval_to_by_id(own_id, opponent_id).present?
      errors.add(:opponent_id, 'トモダチにトモダチ申請を送ることは出来ません')
    end
  end

  def update_approval!
    update!(friend_request_status: :approval)
  end

  def sending?(own)
    own_id == own.id
  end

  def receiving?(own)
    opponent_id == own.id
  end
end
