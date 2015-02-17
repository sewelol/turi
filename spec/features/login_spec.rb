require 'rails_helper'

feature 'Login' do
	
  before do
		@user = FactoryGirl.create(:user)
		visit root_path
		click_link 'Sign In'
	end
  
  scenario 'user can log in' do
		sign_in
    expect(page.current_path).to eq dashboard_path
	end

  scenario 'user type wrong password' do
		fill_in 'user_email', with: @user.email
		fill_in 'user_password', with: 'hello123'
		
		click_button 'Sign In'

    expect(page.current_path).to eq new_user_session_path
	end

  scenario 'logged in user try to log in again' do
		sign_in

		visit new_user_session_path
		expect(page.current_path).to eq dashboard_path

	end

  scenario 'user can log out' do
		sign_in

		click_link 'sign_out_link'
		expect(page).to have_content('Sign In')
		expect(page).to have_content('Sign Up')

		expect(page.current_path).to eq root_path

		visit dashboard_path

		expect(page.current_path).to eq new_user_session_path

  end

  def sign_in
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'sign_in_button'
  end
	
end