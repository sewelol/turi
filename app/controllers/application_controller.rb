class ApplicationController < ActionController::Base

  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise: Override the default sign in redirect
  def after_sign_in_path_for(user)
    dashboard_path
  end

  # Pundit: Custom error handling (you can override this in every controller).
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = I18n.t 'user_not_authorized'
    redirect_to(request.referrer || root_path)
  end

end