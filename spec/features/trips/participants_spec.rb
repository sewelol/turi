
require 'rails_helper'

RSpec.feature 'As an user I want to be able to manage the participants of an existing trip' do

  before do
    logout(:user)
    @owner = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @owner.id)
    @participant_user = FactoryGirl.create(:user)
  end

  scenario 'Trip owner adds editor as participant.' do
    # Prepare
    login_as(@owner, :scope => :user)
    visit trip_participants_path(@trip)
    click_link 'add_participant_button'
    expect(page.current_path).to eq new_trip_participant_path(@trip)

    # Act
    fill_in 'user_email', with: @participant_user.email
    page.check('editor_flag')
    click_button 'save_participant_button'

    # Check
    expect(page.current_path).to eq trip_participants_path(@trip)
    expect(page).to have_content I18n.t('trip_participant_added', :email => @participant_user.email)
    expect(page).to have_content @participant_user.name
    expect(page).to have_content I18n.t('trip_role_editor')
  end

  scenario 'Trip owner adds viewer as participant.' do
    # Prepare
    login_as(@owner, :scope => :user)
    visit trip_participants_path(@trip)
    click_link 'add_participant_button'
    expect(page.current_path).to eq new_trip_participant_path(@trip)

    # Act
    fill_in 'user_email', with: @participant_user.email
    page.uncheck('editor_flag')
    click_button 'save_participant_button'

    # Check
    expect(page.current_path).to eq trip_participants_path(@trip)
    expect(page).to have_content I18n.t('trip_participant_added', :email => @participant_user.email)
    expect(page).to have_content @participant_user.name
    expect(page).to have_content I18n.t('trip_role_viewer')
  end

  scenario 'Trip owner removes participant.' do
    # Prepare
    login_as(@owner, :scope => :user)
    participant = @trip.participants.create(participant_role_id: ParticipantRole.editor.id, user_id: @participant_user.id)

    # Act
    visit trip_participants_path(@trip)
    page.find('#participant-row-' << participant.id.to_s).find('.remove-participant-button').click

    # Check
    expect(page.current_path).to eq trip_participants_path(@trip)
    expect(page).to have_content I18n.t('trip_participant_removed', :email => @participant_user.email)
    expect(page.find_by_id('participant-list')).not_to have_content @participant_user.name
  end

  scenario 'Trip editor removes participant.' do
    # Prepare
    login_as(@owner, :scope => :user)
    participant = @trip.participants.create(participant_role_id: ParticipantRole.editor.id, user_id: @participant_user.id)
    logout(:user)
    login_as(@participant_user, :scope => :user)

    # Act
    visit trip_participants_path(@trip)
    page.find('#participant-row-' << participant.id.to_s).find('.remove-participant-button').click

    # Check
    expect(page.current_path).to eq trip_participants_path(@trip)
    expect(page).to have_content I18n.t('trip_participant_removed', :email => @participant_user.email)
    expect(page.find_by_id('participant-list')).not_to have_content @participant_user.name
  end

  scenario 'Trip viewer can not see participant remove button.' do
    # Prepare
    login_as(@owner, :scope => :user)
    @trip.participants.create(participant_role_id: ParticipantRole.viewer.id, user_id: @participant_user.id)
    logout(:user)
    login_as(@participant_user, :scope => :user)

    # Act
    visit trip_participants_path(@trip)

    # Check
    expect(page.find_by_id('participant-list')).to have_content @participant_user.name
    expect(page.has_no_css?('#participant-list .remove-participant-button')).to be true
  end

  scenario 'Trip viewer can not remove participant.' do
    # Prepare
    login_as(@owner, :scope => :user)
    @trip.participants.create(participant_role_id: ParticipantRole.viewer.id, user_id: @participant_user.id)
    logout(:user)
    login_as(@participant_user, :scope => :user)

    # Act
    visit trip_participants_path(@trip)

    # Check
    expect(page.find_by_id('participant-list')).to have_content @participant_user.name
    expect(page.has_no_css?('#participant-list .remove-participant-button')).to be true
  end

  scenario 'Trip viewer can not visit participant new page.' do
    # Prepare
    login_as(@owner, :scope => :user)
    @trip.participants.create(participant_role_id: ParticipantRole.viewer.id, user_id: @participant_user.id)
    logout(:user)
    login_as(@participant_user, :scope => :user)

    # Act
    visit new_trip_participants_path(@trip)

    # Check
    # TODO: Check for error using authorization gem.
  end

end

