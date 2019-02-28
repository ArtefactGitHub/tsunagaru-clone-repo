FactoryBot.define do
  # factory :admin_user, class: User do
  factory :user do
    name                  {'テストユーザー'}
    email                 {'test1@g.com'}
    password              {'password'}
    password_confirmation {'password'}
    uuid                  {'uuid'}

    after(:build) do |user|
      user.use_type_setting = FactoryBot.build(:use_type_setting)
    end
  end
end
