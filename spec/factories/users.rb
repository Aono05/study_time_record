FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "hoge1234567890@" }
    password_confirmation { "hoge1234567890@" }
    introduction { "はじめましてhoge1です。" }
  end
end
