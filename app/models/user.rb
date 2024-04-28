class User < ApplicationRecord
  PASSWORD_REGEXP = /^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{12,64}$/

  has_many :cheer_messages, dependent: :destroy
  has_many :study_times, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :email, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
  validate :password_complexity
  validates :introduction, length: { maximum: 200 }

  def password_complexity
    return if password.blank?
    return if password =~ PASSWORD_REGEXP

    errors.add :password, I18n.t('activerecord.errors.models.user.attributes.password.blank')
  end


  def update_without_current_password(params, *options)
    delete_password_params(params)
    clean_up_passwords
    update_attributes(params, *options)
  end

  private

  def delete_password_params(params)
    return if params[:password].present?
    return if params[:password_confirmation].present?

    params.delete(:password)
    params.delete(:password_confirmation)
  end
end
