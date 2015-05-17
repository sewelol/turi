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
    expect(page).to_not have_selector(:link_or_button, 'accept_friend_request_' + @userTwo.name)   
    expect(page).to have_selector(:link_or_button, 'remove_request_id')

    click_link 'remove_request_id'

    expect(page).to have_content I18n.t('user_request_destroyed')
    expect(page).to have_selector(:link_or_button, 'create_request_id')
  end

  scenario 'add friend and the other friend accepts on his userpage (via request widget)' do
    click_link 'create_request_id'

    logout
    login_as @userTwo, scope: :user
    visit dashboard_path

    within "#friendship_request_widget" do 
        expect(page).to have_content(@userOne.name)    
        expect(page).to have_selector(:link_or_button, 'accept_friend_request_' + @userOne.name)
        expect(page).to have_selector(:link_or_button, 'remove_friend_request_' + @userOne.name)    
    end
  end

  scenario 'create request and the other friend accept it via the requestors userpage' do
    click_link 'create_request_id'
    logout
    login_as @userTwo, scope: :user
    visit user_path(@userOne)

    expect(page).to have_selector(:link_or_button, 'accept_friend_request_' + @userOne.name)
  end

  scenario 'create request and the added friend can\'t add you' do
    click_link 'create_request_id'
    logout
    login_as @userTwo, scope: :user
    visit user_path @userOne

    expect(page).to_not have_selector(:link_or_button, 'remove_request_id')
    expect(page).to_not have_selector(:link_or_button, 'create_request_id')    
    expect(page).to have_selector(:link_or_button, 'accept_friend_request_' + @userOne.name)
  end



end
