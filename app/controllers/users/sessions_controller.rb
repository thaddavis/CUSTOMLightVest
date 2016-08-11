class Users::SessionsController < Devise::SessionsController

  private
    def after_sign_in_path_for(resource)
      "/"
    end

end
