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
		
		expect(page).to have_content("Welcome")
	end
	
end
