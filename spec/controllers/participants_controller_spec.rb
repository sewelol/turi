require 'rails_helper'

# This test only checks the positive cases.
#
# For authorization tests see spec/policies/participant_policy_spec
#
RSpec.describe ParticipantsController, type: :controller do

  before do
    @owner = FactoryGirl.create(:user)
    @editor = FactoryGirl.create(:user)
    @viewer = FactoryGirl.create(:user)
    @stranger = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    @participant_editor = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @editor.id, participant_role_id: ParticipantRole.editor.id)
    @participant_viewer = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @viewer.id, participant_role_id: ParticipantRole.viewer.id)
    sign_in(@owner)
  end

  describe 'GET #index' do

    it 'should render the index view with all participants' do
      get :index, trip_id: @trip.id
      expect(assigns(:trip)).to be_instance_of(Trip)
      expect(assigns(:participants)).not_to be_nil
      expect(assigns(:participants).count).to eq(3)
    end

  end

  describe 'GET #new' do

    it 'should render the new view' do
      get :new, trip_id: @trip.id
      expect(response).to render_template :new
    end

  end

  describe 'POST #create' do

    it 'should create a trip viewer and redirect to index' do
      initial_participants_count = @trip.participants.count
      expected_participants_count = initial_participants_count + 1

      post :create, trip_id: @trip.id, user_email: @stranger.email

      expect(@trip.participants.count).to eq(expected_participants_count)
      expect(response).to redirect_to trip_participants_path(@trip)
    end

    it 'should rescue error if user is not found and redirect to new with an alert' do
      initial_participants_count = @trip.participants.count

      post :create, trip_id: @trip.id, user_email: 'not@existing.email'

      expect(@trip.participants.count).to eq(initial_participants_count)
      expect(response).to redirect_to new_trip_participant_path(@trip)
      expect(flash[:alert]).to eq I18n.t 'user_not_found'
    end

  end

  describe 'DELETE #destroy' do

    it 'should delete a trip editor and redirect to index' do
      delete :destroy, trip_id: @trip.id, id: @editor.id
      expect(response).to redirect_to trip_participants_path(@trip)
    end

  end

end
