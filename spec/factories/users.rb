FactoryBot.define do
  # factory :admin_user, class: User do
  factory :user do
    name                  {'テストユーザー'}
    sequence(:email)      { |n| "test#{n}@g.com" }
    sequence(:uuid)       { |n| "uuid-#{n}" }
    password              {'password'}
    password_confirmation {'password'}

    after(:build) do |user|
      user.use_type_setting = FactoryBot.build(:use_type_setting)
    end

    trait :admin do
      role                { :admin }
      uuid                {'uuid-admin'}
    end
  end
end
