require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  it "emailとパスワードが認証されること" do
    expect(user).to be_valid
  end
end
