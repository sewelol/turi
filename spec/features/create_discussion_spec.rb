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

  scenario "Create a discussion" do
    # Act
    click_link 'Create discussion'
    title = 'Dette er en diskusjon'
    text = 'La oss diskutere dette temaet som er veldig aktuelt'
    fill_in 'discussion_title', with: title
    fill_in 'discussion_text', with: text

    # Check
    expect(page).to have_content title
    expect(page).to have_content text
  end
end