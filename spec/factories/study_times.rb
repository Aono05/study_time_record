FactoryBot.define do
  factory :study_time do
    started_at            { Time.zone.now }
    ended_at              { Time.zone.now }
    user_id               { 'test user' }
    created_at            { Time.zone.now }
    updated_at            { Time.zone.now }
    memo                  {'有効なメモ'}

    association :user
  end
end