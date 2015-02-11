require 'rails_helper'

feature "Login" do
	before do
		@user=FactoryGirl.create(:account)
		visit "/"
		click_link  "Sign In"
	end
	
	
scenario "user can log in" do
		sign_in
	end


scenario "user type wrong password" do
		fill_in "sign_in_username", with: @user.username
		fill_in "sign_in_password", with: "hello123"
		
		click_button "Sign In"
		
		expect(page).to have_content(I18n.t 'sign_in_failed')
	end

scenario "logged in user try to log in again" do
		sign_in

		visit "/sign_in"
		expect(page.current_path).to eq dashboard_path

	end


scenario "user can log out" do

		sign_in

		click_link "Sign Out"
		expect(page).to have_content("Sign In")
		expect(page).to have_content("Sign Up")

		expect(page.current_path).to eq root_path

		visit 'dashboard'

		expect(page.current_path).to eq sign_in_path

	end
	
end

def sign_in
	fill_in "sign_in_username", with: @user.username
	fill_in "sign_in_password", with: @user.password
		
	click_button "Sign In"	
	expect(page).to have_content((I18n.t 'sign_in_ok') +" #{@user.username}")
end