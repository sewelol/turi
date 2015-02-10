class SessionsController < ApplicationController
	def new
	end

	def create
		user = Account.where(:username => params[:sign_in][:username]).first

		if user && user.authenticate(params[:sign_in][:password])
			session[:account_id] = user.id
			flash[:notice] = "Welcome"
			redirect_to root_url
		else
			flash[:error] = "Not Welcome"
			render :new
		end
	end

end
