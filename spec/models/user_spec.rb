require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Association" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "cheer_messages" do
      let(:target) { :cheer_messages }

      it "Userモデルは、CheerMessageモデルと1対多の関係であること" do
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq(:destroy)
      end
    end

    context "study_times" do
      let(:target) { :study_times }

      it "Userモデルは、StudyTimeモデルと1対多の関係であること" do
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq(:destroy)
      end
    end
  end

  describe "devise modules" do
    it "database_authenticatable moduleを含んでいること" do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it "registerable moduleを含んでいること" do
      expect(User.devise_modules).to include(:registerable)
    end

    it "recoverable moduleを含んでいること" do
      expect(User.devise_modules).to include(:recoverable)
    end

    it "rememberable moduleを含んでいること" do
      expect(User.devise_modules).to include(:rememberable)
    end
  end

  describe "validation" do
    let(:user) { build(:user) }

    context "メールアドレスのバリデーション" do
      it "emailが入力されていること" do
        expect(user).to validate_presence_of(:email)
      end
    end

    context 'パスワードのバリデーション' do
      context "パスワードが正しい形式の場合" do
        let(:password) { "aaaabbbbcccc@1234" }

        it "有効であること" do
          expect(user).to be_valid
        end
      end

      shared_examples "password is invalid" do |password|
        let(:password_error_message) { "パスワードは、12文字以上64文字以下で英字小文字、数字、記号を含めてください。" }

        before do
          user.password = password
        end

        it "無効であること" do
          expect(user).to be_invalid
          expect(user.errors[:password]).to include(password_error_message)
        end
      end

      context "パスワードが空の場合" do
        include_examples "password is invalid", ""
      end

      context "パスワードが正しい形式でない場合" do
        include_examples "password is invalid", "invalid"
      end

      context "パスワードが12文字以下の場合" do
        include_examples "password is invalid", "Short1#!"
      end

      context "パスワードが64文字以上の場合" do
        include_examples "password is invalid", "ThisIsAVeryLongPasswordThatExceedsTheMaximumLengthLimitOf64Characters123#!"
      end

      context "パスワードに数字がない場合" do
        include_examples "password is invalid", "PasswordWithoutNumber#!"
      end

      context "パスワードに記号がない場合" do
        include_examples "password is invalid", "PasswordWithoutSpecialCharacter123"
      end
    end
  end
end
