require 'rails_helper'

RSpec.describe Ranking, type: :model do
  describe ".create_total_week_duration_per_user" do
    let(:run) do
      described_class.create_total_week_duration_per_user(
        started_at: started_at,
        ended_at: ended_at
      )
    end

    before do
      run
    end

    context "集計期間が正しいこと" do
      let(:result) do
        described_class.total_week_duration_latest.find_by(user_id: user.id).total_duration
      end
      let(:based_at) { Time.current }
      let(:started_at) { based_at.ago(1.week).beginning_of_hour }
      let(:ended_at) { based_at.ago(1.hour).end_of_hour }
      let!(:user) { create(:user) }
      let!(:ranking) { create(:ranking, user: user) }

      context "勉強時間が基準日時から直近7日間のみ" do
        let(:expected) { study_times.sum(&:duration) }
        let!(:study_times) do
          (0..6).map do |i|
            create(
              :study_time,
              started_at: started_at + i.days,
              ended_at: started_at + i.days + 1.hour,
              user: user
            )
          end
        end

        it "週間の学習時間ランキングが作成されること" do
          expect(result).to eq(expected)
        end
      end

      context "勉強時間が基準日時から直近7日間および7日間より前を含む" do
        let(:expected) { study_times.sum(&:duration) }
        let!(:study_times) do
          (0..6).map do |i|
            create(
              :study_time,
              started_at: started_at + i.days,
              ended_at: started_at + i.days + 1.hour,
              user: user
            )
          end
        end
        let!(:out_of_range_study_time) do
          create(
            :study_time,
            started_at: started_at - 1.days,
            ended_at: started_at - 1.days + 1.hour,
            user: user
          )
        end

        it "週間の学習時間ランキングが作成されること" do
          expect(result).to eq(expected)
        end
      end

      context "勉強時間が基準日時から直近7日間および基準日時より後を含む" do
        let(:expected) { study_times.sum(&:duration) }
        let!(:study_times) do
          (0..6).map do |i|
            create(
              :study_time,
              started_at: started_at + i.days,
              ended_at: started_at + i.days + 1.hour,
              user: user
            )
          end
        end
        let!(:out_of_range_study_time) do
          create(
            :study_time,
            started_at: started_at + 7.days,
            ended_at: started_at + 7.days + 1.hour,
            user: user
          )
        end

        it "週間の学習時間ランキングが作成されること" do
          expect(result).to eq(expected)
        end
      end

      context "単一ユーザーで集計されること" do
        let(:users_count) { 1 }
        context "ユーザーが1人の場合" do
          it "週間の学習時間ランキングが作成されること" do
            expect(described_class.count).to eq(users_count)
          end
        end

        context "ユーザーが2人以上の場合" do
          let(:users_count) { 2 }
          let!(:another_user) { create(:user) }
          let!(:another_ranking) { create(:ranking, user: another_user) }

          it "週間の学習時間ランキングが作成されること" do
            expect(described_class.count).to eq(users_count)
          end
        end
      end
    end
  end
end
