require 'rails_helper'

RSpec.describe StudyTime, type: :model do
  describe 'Association' do
    context 'user' do
      let(:target) { :user }
      let(:association) do
        described_class.reflect_on_association(target)
      end

      it 'StudyTimeモデルはUserモデルに属していること' do
        expect(association.macro).to eq :belongs_to
      end
    end
  end

  describe 'validation' do
    subject { study_time }
    let(:study_time) { build(:study_time) }

    context 'started_at' do
      it 'presenceが存在する' do
        is_expected.to validate_presence_of :started_at
      end
    end

    context 'ended_at' do
      it 'presenceが存在する' do
        is_expected.to validate_presence_of :ended_at
      end
    end

    context 'メモにNGワードが含まれる場合' do
      it '無効であること' do
        study_time.memo = 'NGワード'
        expect(study_time).not_to be_valid
        expect(study_time.errors[:memo]).to include('にNGワードが含まれています。')
      end
    end

    context 'メモにNGワードが含まれない場合' do
      it '有効であること' do
        expect(study_time).to be_valid
      end
    end
  end

  describe "#duration" do
    subject { study_time.duration }
    let(:study_time) { StudyTime.new(started_at: started_at, ended_at: ended_at) }

    context "終了時間が設定されている場合" do
      context "開始時間より終了時間が遅い場合" do
        let(:expected) { 1 }
        let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
        let(:ended_at) { Time.zone.local(2023, 5, 25, 6, 1, 0) }

        it "1分と表示される" do
          is_expected.to eq expected
        end
      end

      context "開始時間と終了時間が同じ場合" do
        let(:expected) { 0 }
        let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
        let(:ended_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }

        it "0分と表示される" do
          is_expected.to eq expected
        end
      end

      context "開始時間が終了時間より後の場合" do
        let(:expected) { 0 }
        let(:started_at) { Time.zone.local(2023, 5, 25, 6, 1, 0) }
        let(:ended_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }

        it "0分と表示される" do
          is_expected.to eq expected
        end
      end
    end

    context "終了時間が設定されていない場合" do
      let(:expected) { 0 }
      let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
      let(:ended_at) { nil }

      it "0分と表示される" do
        is_expected.to eq expected
      end
    end
  end

  describe "#before_started_on?" do
    let(:study_time) { StudyTime.new(started_at: started_at, ended_at: ended_at) }
    let(:based_on) { Time.zone.local(2023, 5, 26, 6, 0, 0) }

    context "started_atがbased_onの1日前の場合" do
      let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
      let(:ended_at) { Time.zone.local(2023, 5, 25, 7, 0, 0) }

      it "trueが返る" do
        expect(study_time.before_started_on?(based_on)).to eq(true)
      end
    end

    context "started_atがbased_onと同じ日の場合" do
      let(:started_at) { Time.zone.local(2023, 5, 26, 6, 0, 0) }
      let(:ended_at) { Time.zone.local(2023, 5, 26, 7, 0, 0) }

      it "falseが返る" do
        expect(study_time.before_started_on?(based_on)).to eq(false)
      end
    end

    context "started_atがbased_onの1日後の場合" do
      let(:started_at) { Time.zone.local(2023, 5, 27, 6, 0, 0) }
      let(:ended_at) { Time.zone.local(2023, 5, 27, 7, 0, 0) }

      it "falseが返る" do
        expect(study_time.before_started_on?(based_on)).to eq(false)
      end
    end
  end

  describe ".total_duration_for_user" do
    subject { described_class.total_duration_for_user(user) }
    let(:expected) { 180.0 }
    let(:user) { create(:user) }
    let!(:study_times) {
      [
        create(
          :study_time,
          user: user,
          started_at: Time.zone.local(2023, 5, 25, 6, 0, 0),
          ended_at: Time.zone.local(2023, 5, 25, 7, 0, 0)
        ),
        create(
          :study_time,
          user: user,
          started_at: Time.zone.local(2023, 5, 26, 6, 0, 0),
          ended_at: Time.zone.local(2023, 5, 26, 8, 0, 0)
        )
      ]
    }

    it "ユーザーの学習時間の合計が返る" do
      is_expected.to eq expected
    end
  end

  describe ".calculate_consecutive_days" do
    subject { described_class.calculate_consecutive_days(user) }
    let(:user) { create(:user) }

    context "学習時間が連続している場合" do
      let(:expected) { 2 }
      let(:consecutive_calculated_on) { Date.new(2023, 5, 27) }
      let!(:study_times) {
        [
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 26, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 26, 7, 0, 0)
          ),
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 27, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 27, 8, 0, 0)
          )
        ]
      }

      it "ユーザーの連続した学習日数が返る" do
        allow(Time).to receive(:current).and_return(consecutive_calculated_on)
        is_expected.to eq expected
      end
    end

    context "学習時間が連続していない場合" do
      let(:expected) { 0 }
      let(:consecutive_calculated_on) { Date.new(2023, 5, 28) }
      let!(:study_times) {
        [
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 25, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 25, 7, 0, 0)
          ),
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 27, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 27, 8, 0, 0)
          )
        ]
      }

      it "ユーザーの連続した学習日数が返る" do
        allow(Time).to receive(:current).and_return(consecutive_calculated_on)
        is_expected.to eq expected
      end
    end
  end

  describe ".max_consecutive_days_for_user" do
    subject { described_class.max_consecutive_days_for_user(user) }
    let(:user) { create(:user) }

    context "学習時間が連続している場合" do
      let(:expected) { 2 }
      let!(:study_times) {
        [
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 25, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 25, 7, 0, 0)
          ),
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 26, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 26, 8, 0, 0)
          )
        ]
      }

      it "ユーザーの最大連続した学習日数が返る" do
        is_expected.to eq expected
      end
    end

    context "学習時間が連続していない場合" do
      let(:expected) { 1 }
      let!(:study_times) {
        [
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 25, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 25, 7, 0, 0)
          ),
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 27, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 27, 8, 0, 0)
          )
        ]
      }

      it "ユーザーの最大連続した学習日数が返る" do
        is_expected.to eq expected
      end
    end

    context "学習時間が途切れて連続している場合" do
      let(:expected) { 2 }
      let!(:study_times) {
        [
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 25, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 25, 7, 0, 0)
          ),
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 26, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 26, 8, 0, 0)
          ),
          create(
            :study_time,
            user: user,
            started_at: Time.zone.local(2023, 5, 28, 6, 0, 0),
            ended_at: Time.zone.local(2023, 5, 28, 8, 0, 0)
          )
        ]
      }

      it "ユーザーの最大連続した学習日数が返る" do
        is_expected.to eq expected
      end
    end
  end

  describe ".total_duration_per_day" do
    subject { described_class.total_duration_per_day(user) }
    let(:expected) { { "2023-05-25" => 180 } }
    let(:user) { create(:user) }
    let!(:study_times) {
      [
        create(
          :study_time,
          user: user,
          started_at: Time.zone.local(2023, 5, 25, 6, 0, 0),
          ended_at: Time.zone.local(2023, 5, 25, 7, 0, 0)
        ),
        create(
          :study_time,
          user: user,
          started_at: Time.zone.local(2023, 5, 25, 6, 0, 0),
          ended_at: Time.zone.local(2023, 5, 25, 8, 0, 0)
        )
      ]
    }

    it "ユーザーの1日の学習時間の合計が返る" do
      is_expected.to eq expected
    end
  end

  describe ".where_by_duration" do
    subject { described_class.where_by_duration(started_at, ended_at) }
    let(:started_at) { Time.zone.local(2024, 1, 1, 12, 0, 0) }
    let(:ended_at) { Time.zone.local(2024, 1, 2, 14, 0, 0) }
    let(:user) { create(:user) }

    context "指定された時間範囲内のレコードが存在する場合" do
      let!(:study_times) {
        create(
          :study_time,
          user: user,
          started_at: Time.zone.local(2024, 1, 1, 13, 0, 0),
          ended_at: Time.zone.local(2024, 1, 1, 13, 30, 0)
        )
      }

      it "指定された時間範囲内のレコードを返す" do
        is_expected.to eq [study_times]
      end
    end

    context "指定された時間範囲内のレコードが存在しない場合" do
      let(:expected) { [] }
      let!(:studytimes) {
        create(
          :study_time,
          started_at: Time.zone.local(2024, 1, 1, 10, 0, 0),
          ended_at: Time.zone.local(2024, 1, 1, 11, 0, 0)
        )
      }

      it "空の結果を返す" do
        is_expected.to eq expected
      end
    end
  end
end
