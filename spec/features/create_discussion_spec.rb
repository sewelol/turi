require 'rails_helper'

RSpec.feature "Create discussions" do

  before do
    @user = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @user.id)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @user.id, participant_role_id: ParticipantRole.owner.id)
    login_as(@user, scope: :user)
    visit trip_path(@trip)
    click_link 'discussion-btn'
  end

  context "As valid user" do


    scenario "Create a discussion with valid attributes" do
      # Act
      click_link 'create-discussion'
      title = 'Dette er en diskusjon'
      body = 'La oss diskutere dette temaet som er veldig aktuelt'
      fill_in 'discussion_title', with: title
      fill_in 'discussion_body', with: body
      click_button 'save-discussion-btn'

      # Check
      expect(page).to have_content title
      expect(page).to have_content body
    end

    scenario "Create a discussion with invalid attributes" do
      click_link 'create-discussion'
      title = ''
      body = 'whatever'
      fill_in 'discussion_title', with: title
      fill_in 'discussion_body', with: body
      click_button 'save-discussion-btn'

      # Check
      expect()
      expect(page).to render :new
    end
  end
end