class Users::RegistrationsController < Devise::RegistrationsController

  def edit
    render :edit
  end

  # DELETE /resource
  def destroy

    binding.pry

    resultOfDeletingStripeCustomer = DeleteStripeCustomer.call(current_user)
    if !resultOfDeletingStripeCustomer
      set_flash_message! :notice, :delete_stripe_customer_error
      render :edit
      return
    end

    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
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
