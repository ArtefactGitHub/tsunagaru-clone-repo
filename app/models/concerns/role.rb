module Role
  extend ActiveSupport::Concern

  included do
    enum role: {
      general: 0,
      admin: 1
    }

    validates :role, presence: true
  end
end
