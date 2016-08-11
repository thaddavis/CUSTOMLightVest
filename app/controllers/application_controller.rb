class ApplicationController < ActionController::Base
  include Pundit

  before_action :set_paper_trail_whodunnit
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }

  private

    def user_not_authorized
      flash[:alert] = "Access denied."
      redirect_to (request.referrer || root_path)
    end

end
