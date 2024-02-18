require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Association' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'cheer_messages' do
      let(:target) { :cheer_messages }

      it 'Userモデルは、CheerMessageモデルと1対多の関係であること' do
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq(:destroy)
      end

      it 'Userモデルは、StudyTimeモデルと1対多の関係であること' do
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq(:destroy)
      end
    end
  end

  describe 'validation' do
    context 'パスワードのバリデーション' do
      let(:user) { build(:user) }
      let(:password_error_message) { 'パスワードは、12文字以上64文字以下で英字小文字、数字、記号を含めてください。' }

      it "emailとパスワードが有効であること" do
        expect(user).to be_valid
      end

      it 'パスワードが12文字以下の場合、無効であること' do
        user.password = 'Short1#!'
        expect(user).to be_invalid
        expect(user.errors[:password]).to include(password_error_message)
      end

      it 'パスワードが64文字以上の場合、無効であること' do
        user.password = 'ThisIsAVeryLongPasswordThatExceedsTheMaximumLengthLimitOf64Characters123#!'
        expect(user).to be_invalid
        expect(user.errors[:password]).to include(password_error_message)
      end

      it 'パスワードに数字がない場合、無効であること' do
        user.password = 'PasswordWithoutNumber#!'
        expect(user).to be_invalid
        expect(user.errors[:password]).to include(password_error_message)
      end

      it 'パスワードに記号がない場合、無効であること' do
        user.password = 'PasswordWithoutSpecialCharacter123'
        expect(user).to be_invalid
        expect(user.errors[:password]).to include(password_error_message)
      end
    end
  end
end
