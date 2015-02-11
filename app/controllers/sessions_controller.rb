class SessionsController < ApplicationController

  layout 'sign'

	def new
		unless current_user.nil?
			redirect_to dashboard_path
		end

	end

	def create
		

		user = Account.where(:username => params[:sign_in][:username]).first

		if user && user.authenticate(params[:sign_in][:password])
			session[:account_id] = user.id
			#flash[:notice] = "Welcome #{user.username}!"
			flash[:notice] = (I18n.t 'sign_in_ok')+ " #{user.username}!"
			redirect_to '/dashboard'
		else
			flash[:error] = I18n.t 'sign_in_failed'
			render :new
		end
	end

	def destroy

		session[:account_id] = nil
		flash[:notice] = I18n.t 'sign_out_ok'
		redirect_to root_path
	end




end
