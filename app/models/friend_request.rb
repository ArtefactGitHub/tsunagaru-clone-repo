class FriendRequest < ApplicationRecord
  belongs_to :own, class_name: 'User'
  belongs_to :opponent, class_name: 'User'

  validates :own_id, presence: true
  validates :opponent_id, presence: true
  validates :own_id, uniqueness: { scope: :opponent_id }
  validate :can_not_request_to_own

  def can_not_request_to_own
    if opponent_id == own_id
      errors.add(:opponent_id, '自分自身にトモダチ申請を送ることは出来ません')
    end
  end
end
