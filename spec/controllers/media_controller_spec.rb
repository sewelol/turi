require 'rails_helper'

# TODO: Mock the dropbox api to return a valid response and so on.
RSpec.describe MediaController, type: :controller do

  before do
    @owner = FactoryGirl.create(:user)
    @editor = FactoryGirl.create(:user)
    @stranger = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    @participant_editor = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @editor.id, participant_role_id: ParticipantRole.editor.id)
    @access_token_owner = FactoryGirl.create(:api_access_token, trip_id: @trip.id, user_id: @owner.id, api_provider_id: ApiProvider.dropbox.id)
    @access_token_editor = FactoryGirl.create(:api_access_token, trip_id: @trip.id, user_id: @editor.id, api_provider_id: ApiProvider.dropbox.id)
    sign_in(@owner)
  end

  describe 'GET #index' do

    it 'should render the index view with all access tokens' do
      get :index, trip_id: @trip.id
      expect(assigns(:trip)).to be_instance_of(Trip)
      expect(assigns(:access_tokens)).not_to be_nil
      expect(assigns(:access_tokens).count).to eq(ApiAccessToken.all.count)
    end

  end

  describe 'GET #show' do

    it 'should render the show view for dropbox' do

      dummy_dropbox = { :access_token => @access_token_owner, :folders => [] }

      allow_any_instance_of(MediaController).to receive(:initialize_dropbox).and_return(dummy_dropbox)

      get :show, trip_id: @trip.id, id: @access_token_owner

      expect(assigns(:trip)).to be_instance_of(Trip)
      expect(assigns(:access_tokens)).not_to be_nil
      expect(assigns(:access_tokens).count).to eq(ApiAccessToken.all.count)
      expect(assigns(:access_token)).to be_instance_of(ApiAccessToken)
      expect(assigns(:media_user)).to be_instance_of(Hash)
    end

  end

  describe 'DELETE #destroy' do

    it 'should destroy the api access token for dropbox' do

      allow_any_instance_of(ApiAccessToken).to receive(:destroy).and_return(true)

      delete :destroy, trip_id: @trip.id, id: @access_token_owner

      expect(flash[:info]).to eq(I18n.t 'trip_media_account_removed')
      expect(response).to redirect_to trip_media_path(@trip)
    end

    it 'should not destroy the api access token for dropbox of someone else' do
      allow_any_instance_of(ApiAccessToken).to receive(:destroy).and_return(true)

      delete :destroy, trip_id: @trip.id, id: @access_token_editor

      # TODO: Catch the auth error
      expect(response).not_to redirect_to trip_media_path(@trip)
    end

  end

end
