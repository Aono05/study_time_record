class User < ApplicationRecord
  has_many :study_times, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :email, presence: true
  validates :password, presence: true, on: :update, allow_blank: true
  validate :password_complexity
  validates :introduction, length: { maximum: 200 }

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{12,64}$/

    errors.add :password, 'Complexity requirement not met. Length should be 12-64 characters and include: 1 lowercase, 1 digit and 1 special character'
  end
end
