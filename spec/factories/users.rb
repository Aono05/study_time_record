FactoryBot.define do
  factory :user do
    trait :a do
      id { 1 }
      email                 {"hoge1@example.com"}
      password              {"hoge1234567890@"}
      password_confirmation {"hoge1234567890@"}
      introduction          {"はじめましてhoge1です。"}
    end

    trait :b do
      id { 2 }
      email                 {"hoge2@example.com"}
      password              {"hoge1234567890@"}
      password_confirmation {"hoge1234567890@"}
      introduction          {"はじめましてhoge1です。"}
    end
  end
end