FactoryBot.define do
  factory :room do
    name                  { 'テストユーザー' }
    description           { 'テストユーザーの部屋です' }
    updated_at_message    { '2019/01/01' }
    association           :owner, factory: :user
  end
end
