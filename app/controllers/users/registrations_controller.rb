class Users::RegistrationsController < Devise::RegistrationsController

  def create
    if params[:user][:password] == params[:user][:password_confirmation]
      if User.exists?(email: params[:user][:email])
        flash[:alert] = "既に登録されているメールアドレスです"
        redirect_to new_user_registration_path
      else
        super
      end
    else
      flash[:alert] = "パスワードと確認用パスワードが一致しません"
      redirect_to new_user_registration_path
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end
end
