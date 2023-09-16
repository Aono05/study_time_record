class ProfilesController < ApplicationController
  before_action :set_user,only: [:edit, :update]

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
    flash.now[:danger] = "エラーが発生しました: #{e.message}"
    render :edit
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email,:name,:introduction)
  end
end

