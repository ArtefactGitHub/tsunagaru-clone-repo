FactoryBot.define do
  factory :message do
    content               { 'テストメッセージ' }
    association           :user
    association           :room
  end
end
