class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception






def require_signin!
        if current_user.nil?
            flash[:error] = "You must be signed in to create a trip"
            redirect_to sign_in_url

        end
    end

    helper_method :require_signin!
    def current_user
        @current_user ||= Account.find(session[:account_id]) if session[:account_id]
    end

    helper_method :current_user

end