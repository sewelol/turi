require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  before do
    @owner = FactoryGirl.create(:user)
    @editor = FactoryGirl.create(:user)
    @stranger = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip)
    @trip_other = FactoryGirl.create(:trip)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    @participant_editor = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @editor.id, participant_role_id: ParticipantRole.editor.id)
    sign_in(@owner)
  end

  describe 'GET #index' do
    it 'should render the index and assign trip events' do
      event = FactoryGirl.create(:event, trip_id: @trip.id)
      event_second = FactoryGirl.create(:event, trip_id: @trip.id)
      event_other = FactoryGirl.create(:event, trip_id: @trip_other.id)
      get :index, trip_id: @trip.id
      expect(assigns(:trip)).to be_instance_of(Trip)
      expect(assigns(:events)).not_to be_nil
      expect(assigns(:events).count).to eq(2)
      expect(assigns(:events)).to include(event)
      expect(assigns(:events)).to include(event_second)
      expect(assigns(:events)).not_to include(event_other)
      expect(response).to have_rendered :index
    end
  end

  describe 'GET #show' do

    it 'should render show' do
      event = FactoryGirl.create(:event, trip_id: @trip.id)
      get :show, trip_id: @trip.id, id: event.id
      expect(assigns(:trip)).to be_instance_of(Trip)
      expect(assigns(:event)).to be_instance_of(Event)
      expect(assigns(:has_event_coordinates)).to be(true)
      expect(assigns(:event_coordinates)).to be_instance_of(Array)
      expect(response).to have_rendered :show
    end

    it 'should render show with no coordinates for nil location' do
      event = FactoryGirl.create(:event, trip_id: @trip.id)
      event.location = nil
      event.save
      get :show, trip_id: @trip.id, id: event.id
      expect(assigns(:has_event_coordinates)).to be(false)
    end

    it 'should render show with no coordinates for empty location' do
      event = FactoryGirl.create(:event, trip_id: @trip.id)
      event.location = ''
      event.save
      get :show, trip_id: @trip.id, id: event.id
      expect(assigns(:has_event_coordinates)).to be(false)
    end

  end

  describe 'GET #new' do

    it 'should render new with new event' do
      get :new, trip_id: @trip.id
      expect(assigns(:trip)).to be_instance_of(Trip)
      expect(assigns(:event)).to be_instance_of(Event)
      expect(assigns(:event).name).to be_nil
      expect(response).to have_rendered :new
    end

  end

  describe 'GET #edit' do

    it 'should render edit with existing event' do
      event = FactoryGirl.create(:event, trip_id: @trip.id)
      get :edit, trip_id: @trip.id, id: event.id
      expect(assigns(:trip)).to be_instance_of(Trip)
      expect(assigns(:event)).to be_instance_of(Event)
      expect(assigns(:event).name).to eq event.name
      expect(response).to have_rendered :edit
    end

  end

  describe 'POST #create' do

    it 'should create event and redirect to event view' do
      event_attributes = FactoryGirl.attributes_for(:event)
      post :create, trip_id: @trip.id, event: event_attributes
      expect(assigns(:trip)).to be_instance_of(Trip)
      expect(assigns(:event)).to be_instance_of(Event)
      expect(assigns(:event).valid?).to be_truthy
      expect(assigns(:event).name).to eq event_attributes[:name]
      expect(response).to redirect_to trip_event_path @trip, assigns(:event)
    end


    it 'should not create invalid event and render new view with errors' do
      event_attributes = FactoryGirl.attributes_for(:event)
      event_attributes[:name] = nil
      post :create, trip_id: @trip.id, event: event_attributes
      expect(assigns(:event).valid?).to be_falsey
      expect(flash[:alert]).to eq(I18n.t 'trip_event_invalid')
      expect(response).to have_rendered :new
    end

  end

  describe 'PUT #update' do

    it 'should update event and redirect to event view' do
      event = FactoryGirl.create(:event, trip_id: @trip.id)
      put :update, trip_id: @trip.id, id: event, event: event.attributes
      expect(assigns(:trip)).to be_instance_of(Trip)
      expect(assigns(:event)).to be_instance_of(Event)
      expect(assigns(:event).valid?).to be_truthy
      expect(assigns(:event).name).to eq event.name
      expect(response).to redirect_to trip_event_path @trip, assigns(:event)
    end

    it 'should not update an invalid event and render edit view with errors' do
      event = FactoryGirl.create(:event, trip_id: @trip.id)
      event.name = nil
      put :update, trip_id: @trip.id, id: event, event: event.attributes
      expect(assigns(:event).valid?).to be_falsey
      expect(flash[:alert]).to eq(I18n.t 'trip_event_invalid')
      expect(response).to have_rendered :edit
    end

  end

  describe 'DELETE #destroy' do

    it 'should destroy event and redirect to events view' do
      event = FactoryGirl.create(:event, trip_id: @trip.id)
      expect { delete :destroy, trip_id: @trip.id, id: event.id }.to change(Event, :count).by(-1)
      expect(response).to redirect_to trip_events_path @trip
    end

  end

end
