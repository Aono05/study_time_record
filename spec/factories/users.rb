FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "test1234567890@" }
    password_confirmation { "test1234567890@" }
    introduction { "はじめましてtest_userです。" }
  end
end
