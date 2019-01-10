class FriendRequest < ApplicationRecord
  belongs_to :own, class_name: 'User'
  belongs_to :opponent, class_name: 'User'

  validates :own_id, presence: true
  validates :opponent_id, presence: true
end
