module FriendRequestStatus
  extend ActiveSupport::Concern

  included do
    enum friend_request_status: {
      no_progress: 0,
      request: 1,
      approval: 2
    }

    validates :friend_request_status, presence: true
  end
end
