FactoryBot.define do
  factory :user do
    email                 {"hoge1@example.com"}
    password              {"hoge1234567890@"}
    password_confirmation {"hoge1234567890@"}
  end
end
