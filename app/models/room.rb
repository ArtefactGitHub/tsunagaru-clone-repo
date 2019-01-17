class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :users, through: :messages

  validates :name, presence: true

  def meet_the_requirements?(current_user)
    owner == current_user ||
    FriendRequest.pair_bidirectional(current_user, owner).present?
  end
end
