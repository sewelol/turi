require 'rails_helper'

class User

end

feature 'Create Account' do
  before do
    @user = FactoryGirl.build(:user)
    visit root_path

    click_link  'sign_up_button'
  end

  scenario 'can create new account' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'create_account_btn'
    
    expect(page).to have_content(I18n.t('devise.registrations.signed_up'))

  end


  scenario 'password too short' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: '1234'
    fill_in 'user_password_confirmation', with: '1234'

    click_button 'create_account_btn'

    expect(page).to have_content(I18n.t('errors.messages.too_short', attribute: User.human_attribute_name('password'), count: 8))


  end

  scenario 'Password confirmation does not match' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: '12345679'

    click_button 'create_account_btn'

    expect(page).to have_content(I18n.t('errors.messages.confirmation', attribute: User.human_attribute_name('password')))
  end

  scenario 'email already taken' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'create_account_btn'

    click_link('sign_out_link')
    expect(page.current_path).to eq root_path

    click_link  'sign_up_button'

    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'create_account_btn'

    expect(page).to have_content(I18n.t('errors.messages.taken', attribute: User.human_attribute_name('email')))

  end

    scenario 'username already taken' do
    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'create_account_btn'

    click_link('sign_out_link')
    expect(page.current_path).to eq root_path

    click_link  'sign_up_button'

    fill_in 'user_name', with: @user.name
    fill_in 'user_email', with: @user.email << 1
    fill_in 'user_password', with: @user.password
    fill_in 'user_password_confirmation', with: @user.password

    click_button 'create_account_btn'

    expect(page).to have_content(I18n.t('errors.messages.taken'))

  end

end




