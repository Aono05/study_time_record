require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    context 'パスワードのバリデーション' do
      let(:user) { build(:user) }
      let(:password_error_message) { 'パスワードは、12文字以上64文字以下で英字小文字、数字、記号を含めてください。' }

      it "emailとパスワードが有効であること" do
        expect(user).to be_valid
      end
    end
  end
end
