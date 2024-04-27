class User < ApplicationRecord
  PASSWORD_REGEXP = /^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{12,64}$/

  has_many :cheer_messages, dependent: :destroy
  has_many :study_times, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :email, presence: true
  validates :password, presence: true, on: :create
  validate :password_complexity
  validates :introduction, length: { maximum: 200 }

  def password_complexity
    return if password.blank?
    return if password =~ PASSWORD_REGEXP

    errors.add :password, I18n.t('activerecord.errors.models.user.attributes.password.blank')
  end


  def update_without_current_password(params, *options)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end
