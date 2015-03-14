
require 'rails_helper'

RSpec.feature 'Trip event management:' do

  before do
    logout(:user)
    @owner = FactoryGirl.create(:user)
    @editor = FactoryGirl.create(:user)
    @viewer = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    @participant_editor = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @editor.id, participant_role_id: ParticipantRole.editor.id)
    @participant_viewer = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @viewer.id, participant_role_id: ParticipantRole.viewer.id)
    @event = FactoryGirl.create(:event, trip_id: @trip.id)
  end

  scenario 'An trip owner can create an event.' do
    # Prepare
    login_as(@owner, :scope => :user)
    visit trip_events_path(@trip)
    click_link 'add-event-btn'
    expect(page.current_path).to eq new_trip_event_path(@trip)

    # Act
    fill_in 'event_name', with: @event.name
    fill_in 'event_description', with: @event.description
    fill_in 'event_location', with: @event.location
    find('#event_start_date_4i').find(:xpath, 'option[1]').select_option
    find('#event_end_date_4i').find(:xpath, 'option[2]').select_option
    click_button 'save-event-btn'

    # Check
    expect(page).to have_content @event.name
    expect(page).to have_content @event.description
    expect(page).to have_content @event.location
  end

  scenario 'An trip editor can edit an event.' do
    login_as(@editor, :scope => :user)
    visit edit_trip_event_path(@trip, @event)

    new_event_name = 'some-new-name for my event'

    # Act
    fill_in 'event_name', with: new_event_name
    click_button 'save-event-btn'

    # Check
    expect(page).to have_content new_event_name
    expect(page).to have_content @event.description
    expect(page).to have_content @event.location
  end

  scenario 'A trip owner can delete an event.' do
    login_as(@owner, :scope => :user)
    visit trip_event_path(@trip, @event)

    # Act
    click_link 'destroy-event-btn'

    # Check
    expect(page.current_path).to eq trip_events_path(@trip)
    expect(page).to have_content I18n.t('trip_event_destroyed')
  end

end

