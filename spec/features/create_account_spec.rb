require 'rails_helper'

feature "Create Account" do
	before do
		visit "/"
		
		click_link  "Sign Up"
	end
	
	scenario "can create new account" do
		fill_in "account_username", with: "nu_user"
		fill_in "account_email", with: "user@user.com"
		fill_in "account_password", with: "password123"
		fill_in "account_password_confirmation", with: "password123"
		
		click_button "Create Account"
		
		expect(page).to have_content("Account successfully created.")
	end
	

	scenario "password too short" do
		fill_in "account_username", with: "nu_user"
		fill_in "account_email", with: "user@user.com"
		fill_in "account_password", with: "pa"
		fill_in "account_password_confirmation", with: "pa"
		
		click_button "Create Account"
		
		expect(page).to have_content("Password is too short")
	end
	
		scenario "Password confirmation does not match" do
		fill_in "account_username", with: "nu_user"
		fill_in "account_email", with: "user@user.com"
		fill_in "account_password", with: "password123"
		fill_in "account_password_confirmation", with: "password12"
		
		click_button "Create Account"
		
		expect(page).to have_content("Password confirmation doesn't match Password")
	end
	
	scenario "username already taken" do
		fill_in "account_username", with: "nu_user"
		fill_in "account_email", with: "user@user.com"
		fill_in "account_password", with: "password123"
		fill_in "account_password_confirmation", with: "password123"
		
		click_button "Create Account"
		
		visit "/"
		click_link  "Sign Up"
		
		fill_in "account_username", with: "nu_user"
		fill_in "account_email", with: "user@user.com"
		fill_in "account_password", with: "password123"
		fill_in "account_password_confirmation", with: "password123"
		
		click_button "Create Account"
		
		expect(page).to have_content("Username has already been taken")
	end

	scenario "email already taken" do
		fill_in "account_username", with: "nu_user"
		fill_in "account_email", with: "user@user.com"
		fill_in "account_password", with: "password123"
		fill_in "account_password_confirmation", with: "password123"
		
		click_button "Create Account"
		
		visit "/"
		click_link  "Sign Up"
		
		fill_in "account_username", with: "nu_user69"
		fill_in "account_email", with: "user@user.com"
		fill_in "account_password", with: "password123"
		fill_in "account_password_confirmation", with: "password123"
		
		click_button "Create Account"
		
		expect(page).to have_content("Email has already been taken")
	end

end




