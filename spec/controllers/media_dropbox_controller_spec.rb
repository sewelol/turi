require 'rails_helper'

RSpec.describe MediaDropboxController, type: :controller do

  before do
    @owner = FactoryGirl.create(:user)
    @stranger = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    @access_token_owner = FactoryGirl.create(:api_access_token, trip_id: @trip.id, user_id: @owner.id, api_provider_id: ApiProvider.dropbox.id)
    sign_in(@owner)
  end

  describe 'GET #auth_start' do

    it 'should redirect to the generated dropbox auth url' do

      session[:dropbox_workflow_started] = false
      session[:dropbox_trip_id] = nil

      expected_auth_url = 'http://google.de'

      allow_any_instance_of(DropboxOAuth2Flow).to receive(:start).and_return(expected_auth_url)

      get :auth_start, trip_id: @trip.id, user_id: @owner.id

      expect(session[:dropbox_workflow_started]).to be_truthy
      expect(session[:dropbox_trip_id]).to eq(@trip.id)
      expect(response).to redirect_to expected_auth_url

    end

  end

  describe 'GET #auth_finish' do

    it 'should redirect to trip page after receiving the token' do

      session[:dropbox_workflow_started] = true
      session[:dropbox_trip_id] = @trip.id

      expect(ApiAccessToken).to receive(:create)
      allow_any_instance_of(DropboxOAuth2Flow).to receive(:finish).and_return('token12308hdkjdshladkl')

      get :auth_finish, trip_id: @trip.id, user_id: @owner.id

      expect(session[:dropbox_workflow_started]).to be_falsey
      expect(session[:dropbox_trip_id]).to be_nil
      expect(response).to redirect_to trip_media_path(@trip)

    end

  end

end
