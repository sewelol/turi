class SessionsController < ApplicationController
	def new
	end

	def create
		user = Account.where(:username => params[:sign_in][:username]).first

		if user && user.authenticate(params[:sign_in][:password])
			session[:account_id] = user.id
			flash[:notice] = "Welcome #{user.username}!"
			redirect_to root_url
		else
			flash[:error] = "Not Welcome"
			render :new
		end
	end

	def destroy

		session[:account_id] = nil
		flash[:notice] = "You have now signed out of this wonderful app"
		redirect_to root_path
	end




end
