require 'rails_helper'

feature 'request' do
  before do
    @userOne = FactoryGirl.create(:user)
    @userTwo = FactoryGirl.create(:user)
    login_as @userOne, scope: :user
    visit user_path @userTwo
  end

  scenario 'create valid request' do
    click_link 'create_request_id'

    expect(page).to have_content I18n.t('user_request_added')
    expect(page).to_not have_selector(:link_or_button, 'create_request_id')
    expect(page).to have_selector(:link_or_button, 'remove_request_id')
  end
end