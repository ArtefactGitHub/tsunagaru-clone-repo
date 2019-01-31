module UseType
  extend ActiveSupport::Concern

  included do
    enum use_type: {
      use_normal: 0,
      only_chat: 1
    }

    validates :use_type, presence: true
  end
end
