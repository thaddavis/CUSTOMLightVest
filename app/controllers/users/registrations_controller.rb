class Users::RegistrationsController < Devise::RegistrationsController

  def edit
    render :edit
  end

  private

    def after_sign_up_path_for(resource)
      '/'
    end

    def sign_up_params
      params.require(:user).permit(:username, :first_name, :middle_name, :last_name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.require(:user).permit(:username, :first_name, :middle_name, :last_name, :email, :password, :password_confirmation, :current_password)
    end

end
