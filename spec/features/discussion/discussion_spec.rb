require 'rails_helper'

RSpec.feature "Discussions" do

  before do
    @user = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @user.id)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @user.id, participant_role_id: ParticipantRole.owner.id)
    @discussion = FactoryGirl.create(:discussion, trip_id: @trip.id, user_id: @user.id)
    login_as(@user, scope: :user)
    visit trip_path(@trip)
    click_link 'discussion-btn'
  end

  context "as valid user" do

    context "create a discussion" do
      scenario "with valid attributes" do
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
        expect(page).to have_content I18n.t 'discussion_created'
      end

      scenario "with invalid attributes" do
        click_link 'create-discussion'
        title = ''
        body = 'whatever'
        fill_in 'discussion_title', with: title
        fill_in 'discussion_body', with: body
        click_button 'save-discussion-btn'

        # Check
        expect(page).to have_content I18n.t 'discussion_not_created'
      end
    end

    scenario "read a discussion" do
      click_link "discussion_" << @discussion.id.to_s
      expect(page).to have_content @discussion.title
      expect(page).to have_content @discussion.body
    end

    context "Update a discussion" do
      before do
        click_link "discussion_" << @discussion.id.to_s
        click_link 'edit-discussion-btn'
      end

      scenario "with valid attributes" do
        title = 'dette er en valid diskusjons tittel'
        body = 'her kan det stå hva som helst ass'
        fill_in 'discussion_title', with: title
        fill_in 'discussion_body', with: body
        click_button 'save-discussion-btn'

        # Check
        expect(page).to have_content I18n.t 'discussion_updated'
        expect(page).to have_content title
        expect(page).to have_content body
      end

      scenario "with invalid attributes" do
        title = ''
        body = 'whatever'
        fill_in 'discussion_title', with: title
        fill_in 'discussion_body', with: body
        click_button 'save-discussion-btn'

        # Check
        expect(page).to have_content I18n.t 'discussion_not_updated'
      end

      scenario "but decides to cancel" do
        click_button 'cancel-save-discussion-btn'

        expect(page).to have_content @discussion.title
        expect(page).to have_content @discussion.body
      end
    end

    scenario "destroy a discussion" do
      title = @discussion.title
      click_link "discussion_" << @discussion.id.to_s
      click_link 'destroy-discussion-btn'


      expect(page).to have_content I18n.t 'discussion_destroyed'
      expect(page).to_not have_content title
    end
  end
end