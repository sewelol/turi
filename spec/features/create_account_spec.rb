require 'rails_helper'

feature "Create Account" do
	before do
		visit "/"
		
		click_link  "Sign Up"
	end
	
	scenario "can create new account" do
		fill_in "Username", with: "nu_user"
		fill_in "Email", with: "user@user.com"
		fill_in "Password", with: "password123"
		fill_in "Confirm password", with: "password123"
		
		click_button "Create Account"
		
		expect(page).to have_content("Account successfully created.")
	end
	

	scenario "password too short" do
		fill_in "Username", with: "nu_user"
		fill_in "Email", with: "user@user.com"
		fill_in "Password", with: "pa"
		fill_in "Confirm password", with: "pa"
		
		click_button "Create Account"
		
		expect(page).to have_content("Password is too short")
	end
	
		scenario "Password confirmation does not match" do
		fill_in "Username", with: "nu_user"
		fill_in "Email", with: "user@user.com"
		fill_in "Password", with: "password123"
		fill_in "Confirm password", with: "password12"
		
		click_button "Create Account"
		
		expect(page).to have_content("Password confirmation doesn't match Password")
	end
	
	scenario "username already taken" do
		fill_in "Username", with: "nu_user"
		fill_in "Email", with: "user@user.com"
		fill_in "Password", with: "password123"
		fill_in "Confirm password", with: "password123"
		
		click_button "Create Account"
		
		visit "/"
		click_link  "Sign Up"
		
		fill_in "Username", with: "nu_user"
		fill_in "Email", with: "user@user.com"
		fill_in "Password", with: "password123"
		fill_in "Confirm password", with: "password123"
		
		click_button "Create Account"
		
		expect(page).to have_content("Username has already been taken")
	end

	scenario "email already taken" do
		fill_in "Username", with: "nu_user"
		fill_in "Email", with: "user@user.com"
		fill_in "Password", with: "password123"
		fill_in "Confirm password", with: "password123"
		
		click_button "Create Account"
		
		visit "/"
		click_link  "Sign Up"
		
		fill_in "Username", with: "nu_user69"
		fill_in "Email", with: "user@user.com"
		fill_in "Password", with: "password123"
		fill_in "Confirm password", with: "password123"
		
		click_button "Create Account"
		
		expect(page).to have_content("Email has already been taken")
	end

end




