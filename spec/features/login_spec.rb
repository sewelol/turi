require 'rails_helper'

feature "Login" do
	before do
		@user=FactoryGirl.create(:account)
		visit "/"
		click_link  "Sign In"
	end
	
	
scenario "user can log in" do
		fill_in "sign_in_username", with: @user.username
		fill_in "sign_in_password", with: @user.password
		
		click_button "Sign In"
		
		expect(page).to have_content("Welcome #{@user.username}")
	end




scenario "user can log out" do
		fill_in "sign_in_username", with: @user.username
		fill_in "sign_in_password", with: @user.password
		
		click_button "Sign In"
		
		expect(page).to have_content("Welcome #{@user.username}")

		click_link "sign_out_link"
		expect(page).to have_content("Sign In")
		expect(page).to have_content("Sign Up")

	end
	
end
