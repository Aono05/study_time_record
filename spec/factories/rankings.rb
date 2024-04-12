FactoryBot.define do
  factory :ranking do
    association :user
    total_duration { 420 }  # 任意の合計学習時間を設定
    chunk_id { 1 }          # 任意の chunk_id を設定
  end
end
