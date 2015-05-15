require 'rails_helper'

RSpec.feature 'Friendship' do
  before do
    @userOne = FactoryGirl.create(:user)
    @userTwo = FactoryGirl.create(:user)

    login_as(@userOne, scope: :user)

  end

  context 'with request made' do
    before do
      @friendRequest = FactoryGirl.create(:request, user_id: @userOne.id, receiver_id: @userTwo.id)
      visit user_path @userOne
    end

    context 'accepts a request' do
      before do
        click_link "accept_friend_request_#{@userTwo.id}"
      end

      scenario 'the view is correct for the user' do
        expect(page).to have_content(I18n.t('user_friendship_confirmed'))
        expect(page).to_not have_selector(:link_or_button, "accept_friend_request_#{@userTwo.id}")

        within("#my-friends") do
          expect(page).to have_content "#{@userTwo.name}"
          expect(page).to have_selector(:link_or_button, "delete_friend_#{@userTwo.id}")
        end

        click_link "delete_friend_#{@userTwo.id}"

        within("#my-friends") do
          expect(page).to_not have_content "#{@userTwo.name}"
          expect(page).to_not have_selector(:link_or_button, "delete_friend_#{@userTwo.id}")
        end
      end

      scenario 'the view is correct for the added friend' do
        logout
        login_as(@userTwo, scope: :user)
        visit user_path @userTwo

        within("#my-friends") do
          expect(page).to have_content "#{@userOne.name}"
          expect(page).to have_selector(:link_or_button, "delete_friend_#{@userOne.id}")
        end

        click_link "delete_friend_#{@userOne.id}"

        within("#my-friends") do
          expect(page).to_not have_content "#{@userOne.name}"
          expect(page).to_not have_selector(:link_or_button, "delete_friend_#{@userOne.id}")
        end
      end

      scenario 'it is removed for the unfriended' do
        click_link "delete_friend_#{@userTwo.id}"
        logout
        login_as(@userTwo, scope: :user)
        visit user_path @userTwo

        within("#my-friends") do
          expect(page).to_not have_content "#{@userOne.name}"
          expect(page).to_not have_selector(:link_or_button, "delete_friend_#{@userOne.id}")
        end
      end
    end

  end

  context 'without request made' do
    scenario 'there is no button to accept a friendship' do
      visit user_path @userOne

      within("#friend-requests") do
        expect(page).to_not have_content "accept_friend_request_#{@userTwo.id}"
      end
    end
  end
end