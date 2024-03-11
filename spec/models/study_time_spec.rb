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
    let(:study_time) { build(:study_time) }

    context 'started_atが存在する場合' do
      it '有効であること' do
        expect(study_time).to be_valid
      end
    end

    context 'started_atが存在しない場合' do
      let(:study_time) { build(:study_time, started_at: started_at) }
      let(:started_at) { [] }

      it '無効であること' do
        expect(study_time).to be_invalid
      end

      it { expect(study_time).to validate_presence_of :started_at }
      #どちらが良いか確認
    end

    context 'ended_atが存在する場合' do
      it '有効であること' do
        expect(study_time).to be_valid
      end
    end

    context 'ended_atが存在しない場合' do
      let(:study_time) { build(:study_time, ended_at: ended_at) }
      let(:ended_at) { [] }

      it '無効であること' do
        expect(study_time).to be_invalid
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
    let(:study_time) { StudyTime.new(started_at: started_at, ended_at: ended_at) }

      context "終了時間が設定されている場合" do
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
        let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
        let(:ended_at) { nil }
        let(:expected) { 0 }

        it "0分と表示される" do
          expect(study_time.duration).to eq(expected)
        end
      end
  end

  describe "#before_started_on?" do
    let(:study_time) { StudyTime.new(started_at: started_at, ended_at: ended_at) }

      context "started_atがbased_onの1日前と一致する場合" do
        let(:based_on) { Time.zone.local(2023, 5, 26, 6, 0, 0) }
        let(:started_at) { Time.zone.local(2023, 5, 25, 6, 0, 0) }
        let(:ended_at) { Time.zone.local(2023, 5, 25, 7, 0, 0) }

        it "trueが返る" do
          expect(study_time.before_started_on?(based_on)).to eq(true)
        end
      end
  end
end
