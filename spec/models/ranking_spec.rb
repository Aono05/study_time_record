require 'rails_helper'

RSpec.describe Ranking, type: :model do
  describe ".create_total_week_duration_per_user" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:start_time) { Time.zone.local(2024, 1, 1, 0, 0, 0) }
    let(:end_time) { Time.zone.local(2024, 1, 7, 23, 59, 59) }

    before do
      create(:study_time, user: user1, started_at: start_time, ended_at: start_time + 1.hour)
      create(:study_time, user: user1, started_at: start_time + 1.day, ended_at: start_time + 1.day + 2.hours)
      create(:study_time, user: user2, started_at: start_time, ended_at: start_time + 2.hours)
    end

    it "週間の学習時間ランキングが作成されること" do
      expect {
        described_class.create_total_week_duration_per_user(started_at: start_time, ended_at: end_time)
      }.to change { Ranking.count }.by(2)

      expect(Ranking.pluck(:user_id, :total_duration)).to include([user1.id, 26], [user2.id, 120])
    end
  end

  describe ".total_week_duration_latest" do
    let!(:ranking1) { create(:ranking, total_duration: 100, chunk_id: 1) }
    let!(:ranking2) { create(:ranking, total_duration: 200, chunk_id: 1) }
    let!(:ranking3) { create(:ranking, total_duration: 150, chunk_id: 2) }

    it "最も最近の週のランキングが取得されること" do
      expect(described_class.total_week_duration_latest).to eq([ranking2, ranking3])
    end
  end
end