require 'rails_helper'

RSpec.describe Ranking, type: :model do
  describe ".create_total_week_duration_per_user" do
    let(:user1) { create(:user, :a) }
    let(:user2) { create(:user, :b) }
    let(:study_time) { create(:study_time, user: user) }
    let(:started_at) { Time.zone.local(2024, 1, 1, 0, 0, 0) }
    let(:ended_at) { Time.zone.local(2024, 1, 7, 23, 59, 59) }

    before do
      create(
        :study_time,
        user: user1,
        started_at: started_at,
        ended_at: started_at + 1.hour
      )
      create(
        :study_time,
        user: user1,
        started_at: started_at + 1.day,
        ended_at: started_at + 1.day + 2.hours
      )
      create(
        :study_time,
        user: user2,
        started_at: started_at,
        ended_at: started_at + 2.hours
      )
    end

    it "週間の学習時間ランキングが作成されること" do
      expect {
        described_class.create_total_week_duration_per_user(
          started_at: started_at,
          ended_at: ended_at
        )
      }.to change(described_class, :count).by(2)
    end

    it "週間の学習時間ランキングが正しく作成されること" do
      described_class.create_total_week_duration_per_user(
        started_at: started_at,
        ended_at: ended_at
      )

      expect(Ranking.find_by(user_id: user1.id).total_duration).to eq(180)
      expect(Ranking.find_by(user_id: user2.id).total_duration).to eq(120)
    end
  end

  describe ".total_week_duration_latest" do
    let(:user1) { create(:user, :a) }
    let(:user2) { create(:user, :b) }

    it "最新の週間の学習時間ランキングが取得できること" do
      create(:ranking, user: user1, total_duration: 180)
      create(:ranking, user: user2, total_duration: 120)

      latest_rankings = described_class.total_week_duration_latest

      # ランキングが期待通りの順序で取得されるか確認
      expect(latest_rankings.pluck(:user_id)).to eq([user1.id, user2.id])

      # ランキングが合計学習時間の降順で並び替えられているかどうかを検証
      expect(latest_rankings.first.total_duration).to be >= latest_rankings.last.total_duration
    end
  end
end


