require 'rails_helper'

class User

end

feature 'Create Account' do
  before do
    @user = FactoryGirl.create(:user)
    visit root_path

    click_link  'Sign Up'
  end

  scenario 'can create new account' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'Create Account'
    expect(page.current_path).to eq dashboard_path
  end


  scenario 'password too short' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'Create Account'

    #expect(page).to have_content('Password is too short')
    expect(page.current_path).to eq new_user_registration_path


  end

  scenario 'Password confirmation does not match' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: '12345679'

    click_button 'Create Account'

    expect(page).to have_content('Password confirmation doesn\'t match Password')
  end

  scenario 'username already taken' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'Create Account'

    visit root_path
    click_link  'Sign Up'

    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email << '1'
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'Create Account'

    expect(page.current_path).to eq new_user_registration_path
  end

  scenario 'email already taken' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'Create Account'

    visit root_path
    click_link  'Sign Up'

    fill_in 'user_name', with: @user.name << '1'
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'Create Account'

    expect(page.current_path).to eq new_user_registration_path
  end

end




