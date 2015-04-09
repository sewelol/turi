require 'rails_helper'

RSpec.feature "Comments" do
  before do
    @user = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @user.id)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @user.id, participant_role_id: ParticipantRole.owner.id)
    @discussion = FactoryGirl.create(:discussion, trip_id: @trip.id, user_id: @user.id)
    login_as(@user, scope: :user)
    visit trip_path(@trip)
    click_link 'discussion-btn'
    click_link 'discussion_' << @discussion.id.to_s
  end

  context "create a comment" do
    scenario "with valid attributes" do
      body = 'This is my body, this is my mind'
      fill_in 'comment_body', with: body
      click_button 'save-comment-btn'

      within("#comment-list") do
        expect(page).to have_content body
      end
    end

    scenario "with invalid attributes" do
      old_page = page
      fill_in 'comment_body', with: ''
      click_button 'save-comment-btn'
      expect(page).to eql(old_page)
    end
  end
end