class ProfilesController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update!(user_params)
      redirect_to profile_path, success: "プロフィールを更新しました"
    else
      set_alert("プロフィールを更新できませんでした")
      render :edit
    end
  rescue StandardError => e
    Rails.logger.error("failed to update user profile. error: #{e}, message: #{e.message}")
    set_alert("エラーが発生してプロフィールを更新できませんでした")
    render :edit
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name, :introduction)
  end
end

