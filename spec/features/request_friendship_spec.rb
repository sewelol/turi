require 'rails_helper'

RSpec.feature 'Request and friendship' do
  before do
    @userOne = FactoryGirl.create(:user)
    @userTwo = FactoryGirl.create(:user)

    login_as(@userOne, scope: :user)
  end

  context 'create a friend request' do
    scenario 'visit friend page and make a request, then login as other user and accept request' do
      visit user_path @userTwo

      within "#request-friend" do
        click_link 'create_request_id'
      end

      logout
      login_as @userTwo, scope: :user

      visit user_path @userOne

      within "#request-friend" do
        expect(page).to have_selector(:link_or_button, "remove_request_id")
      end

      visit user_path @userTwo

      click_link "accept_friend_request_#{@userOne.id}"

      within "#my-friends" do
        expect(page).to have_content @userOne.name
        expect(page).to have_selector(:link_or_button, "delete_friend_#{@userOne.id}")
      end

      visit user_path @userOne

      within "#my-friends" do
        expect(page).to have_content @userTwo.name
        # Should not be able to delete friend from another user
        expect(page).to_not have_selector(:link_or_button, "delete_friend_#{@userTwo.id}")
      end

      within "#request-friend" do
        expect(page).to_not have_selector(:link_or_button, "remove_request_id")
      end

      visit user_path @userTwo

      click_link "delete_friend_#{@userOne.id}"

      within "#my-friends" do
        expect(page).to_not have_content @userOne.name
      end

      logout
      login_as @userOne, scope: :user

      visit user_path @userOne

      within "#my-friends" do
        expect(page).to_not have_content @userTwo.name
      end

      visit user_path @userTwo

      within "#request-friend" do
        expect(page).to have_selector(:link_or_button, "create_request_id")
      end
    end
  end
end