FactoryBot.define do
  factory :study_time do
    started_at            { Time.current }
    ended_at              { Time.current }
    user_id               { 'test user' }
    created_at            { Time.current }
    updated_at            { Time.current }
    memo                  {'有効なメモ'}

    association :user
  end
end
