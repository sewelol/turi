require 'rails_helper'

feature 'request' do
  before do
    @userOne = FactoryGirl.create(:user)
    @userTwo = FactoryGirl.create(:user)
    login_as @userOne, scope: :user
    visit user_path(@userTwo)
  end

  scenario 'create valid request and remove it' do

    click_link 'create_request_id'

    expect(page).to have_content I18n.t('user_request_added')
    expect(page).to_not have_selector(:link_or_button, 'create_request_id')
    expect(page).to have_selector(:link_or_button, 'remove_request_id')

    click_link 'remove_request_id'

    expect(page).to have_content I18n.t('user_request_destroyed')
    expect(page).to have_selector(:link_or_button, 'create_request_id')
  end

  context 'add friend and the other friend accepts' do

  end

  scenario 'create request and the added friend can\'t add you' do
    click_link 'create_request_id'
    logout
    login_as @userTwo, scope: :user
    visit user_path @userOne

    expect(page).to_not have_selector(:link_or_button, 'create_request_id')
    expect(page).to have_selector(:link_or_button, 'remove_request_id')
  end

  scenario 'create request and the added friend can accept it' do

  end

end