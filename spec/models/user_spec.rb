require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with email and password" do
    user = User.new(
        email: "hoge1@example.com",
        password: "hoge1234567890@"
    )
    expect(user).to be_valid
  end
end
