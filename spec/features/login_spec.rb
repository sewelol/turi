require 'rails_helper'

feature "Login" do
	before do
		@user=FactoryGirl.create(:account)
		visit "/"
		click_link  "Sign In"
	end
	

scenario "user type wrong password" do
		fill_in "Username", with: @user.username
		fill_in "Password", with: "hello123"
		
		click_button "Sign In"
		
		expect(page).to have_content("Not Welcome")
	end
	
scenario "user can log in" do
		fill_in "Username", with: @user.username
		fill_in "Password", with: @user.password
		
		click_button "Sign In"
		
		expect(page).to have_content("Welcome #{@user.username}")
	end

scenario "logged in user try to log in again" do
		fill_in "Username", with: @user.username
		fill_in "Password", with: @user.password
		
		click_button "Sign In"
		
		expect(page).to have_content("Welcome #{@user.username}")

		visit "/sign_in"
		expect(page).to have_content("You are already signed in!")

	end

scenario "user try to log out" do
		fill_in "Username", with: @user.username
		fill_in "Password", with: @user.password
		
		click_button "Sign In"
		
		expect(page).to have_content("Welcome #{@user.username}")

		click_link "Sign Out"
		expect(page).to have_content("You have now signed out")
		expect(page).to have_content("Sign In")

		click_link "Create Trip"	# Check if logged out
		expect(page).to have_content("You must be signed in to create a trip")

	end
	
end
