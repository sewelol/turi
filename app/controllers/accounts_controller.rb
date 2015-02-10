class AccountsController < ApplicationController
	def new
		@account = Account.new
	end
	
	def show
	  
	end
	
	def edit
	end
	
	def create
		@account = Account.new(account_params)
		if @account.save
			flash[:notice] = "Account successfully created."
			redirect_to @account
		else
		  render :new # Go back to the registration form to display any errors to the user. See 'new.html.erb'
		end
	end
	
	
	
	private
	
	def account_params
		params.require(:account).permit(:username, :email, :password, :password_confirmation)
	end
end
