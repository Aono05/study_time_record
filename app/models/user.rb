class User < ApplicationRecord
  PASSWORD_REGEXP = /^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{12,64}$/

  has_many :cheer_messages, dependent: :destroy
  has_many :study_times, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :email, presence: true
  validates :password, presence: true, on: :update, allow_blank: true 
  # FIXME: allow_blankしていると空文字を許容してしまうので許容しないように修正する必要がある
  validate :password_complexity
  validates :introduction, length: { maximum: 200 }

  def password_complexity
    return if password.blank?
    return if password =~ PASSWORD_REGEXP

    errors.add :password, 'パスワードは、12文字以上64文字以下で英字小文字、数字、記号を含めてください。'
  end
end
