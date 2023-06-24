require 'rails_helper'

RSpec.describe StudyTime, type: :model do
  describe "#duration" do
    context "終了時間が設定されている場合" do
        let(:study_time) { StudyTime.new(started_at: started_at, ended_at: ended_at) }

      context "開始時間より終了時間が遅い場合" do
        let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
        let(:ended_at) { Time.zone.local(2023, 5, 25, 6, 1, 0) }
        let(:expected) { 1 }

        it "1分と表示される" do
          expect(study_time.duration).to eq(expected)
        end
      end

      context "開始時間と終了時間が同じ場合" do
        let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
        let(:ended_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
        let(:expected) { 0 }

        it "0分と表示される" do
          expect(study_time.duration).to eq(expected)
        end
      end

      context "開始時間が終了時間より後の場合" do
        let(:started_at) { Time.zone.local(2023, 5, 25, 6, 1, 0) }
        let(:ended_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
        let(:expected) { 0 }

        it "0分と表示される" do
          expect(study_time.duration).to eq(expected)
        end
      end
    end

    context "終了時間が設定されていない場合" do
      let(:study_time) { StudyTime.new(started_at: started_at, ended_at: ended_at) }
      let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
      let(:ended_at) { nil }
      let(:expected) { 0 }

      it "0分と表示される" do
        expect(study_time.duration).to eq(expected)
      end
    end
  end
end
