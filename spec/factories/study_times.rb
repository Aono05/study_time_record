FactoryBot.define do
  factory :study_time do
    started_at            { Time.current }
    ended_at              { Time.current }
    memo                  {'有効なメモ'}
    
    association :user
  end
end
