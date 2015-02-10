require 'rails_helper'

feature "Login" do
	before do
		@user=FactoryGirl.create(:account)
		visit "/"
		click_link  "Sign In"
	end
	
	
scenario "user can log in" do
		fill_in "Username", with: @user.username
		fill_in "Password", with: @user.password
		
		click_button "Sign In"
		
		expect(page).to have_content("Welcome #{@user.username}")
	end




scenario "user can log out" do
		fill_in "Username", with: @user.username
		fill_in "Password", with: @user.password
		
		click_button "Sign In"
		
		expect(page).to have_content("Welcome #{@user.username}")

		click_link "Sign Out"
		expect(page).to have_content("You have now signed out")
		expect(page).to have_content("Sign In")

	end
	
end
