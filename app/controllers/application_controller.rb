class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


def require_signin!
        if current_user.nil?
            flash[:error] = I18n.t 'sign_in_to_create_trip'
            redirect_to sign_in_url

        end
    end

    helper_method :require_signin!
    def current_user
    	unless Account.count < 1
        	@current_user ||= Account.find(session[:account_id]) if session[:account_id]
        end
    end

    helper_method :current_user

end