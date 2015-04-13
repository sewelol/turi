require 'rails_helper'

RSpec.describe DiscussionsController, type: :controller do
  before do
    @owner = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @owner.id)
    FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    sign_in(@owner)
  end

  describe 'GET #index' do
    it 'Renders the index template' do
      discussion = FactoryGirl.create(:discussion, trip_id: @trip, user_id: @owner)
      get :index,
          trip_id: @trip.id
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    it "renders the new template" do
      get :new, trip_id: @trip.id
      expect(response).to render_template :new
    end

  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new discussion' do
        expect {
          post :create,
               trip_id: @trip.id,
               discussion: FactoryGirl.attributes_for(:discussion),
               user_id: @owner
        }.to change(Discussion, :count).by(1)
        expect(response).to redirect_to trip_discussion_path @trip, assigns(:discussion)
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t create a new discussion' do
        expect {
          post :create,
               discussion: {title: '', body: ''},
               trip_id: @trip.id
        }.to change(Discussion, :count).by(0)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    it 'renders  the edit template' do
      discussion = FactoryGirl.create(:discussion, trip_id: @trip.id)
      get :edit,
          trip_id: @trip.id,
          id: discussion.id
      expect(response).to render_template :edit
    end

  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'locates the requested discussion' do
        discussion = FactoryGirl.create(:discussion, trip_id: @trip.id)
        put :update,
            trip_id: @trip.id,
            id: discussion.id,
            discussion: FactoryGirl.attributes_for(:discussion)
        expect(assigns(:discussion)).to eql(discussion)
      end

      it 'changes the discussion attributes and redirects to discussion' do
        discussion = FactoryGirl.create(:discussion, trip_id: @trip.id)
        title = 'Yolo discussion'
        body = 'Dis discussion is out of ctrl'
        put :update,
            trip_id: @trip.id,
            id: discussion.id,
            discussion: {title: title, body: body}
        discussion.reload
        expect(discussion.title).to eql(title)
        expect(discussion.body).to eql(body)
        expect(response).to redirect_to trip_discussion_path @trip, discussion
      end
    end

    context 'with invalid attributes' do
      it 'locates the requested discussion' do
        discussion = FactoryGirl.create(:discussion, trip_id: @trip.id)
        put :update,
            trip_id: @trip.id,
            id: discussion.id,
            discussion: {body: ''}
        expect(assigns(:discussion)).to eql(discussion)
      end

      it 'doesnt change the discussion attributes and re-renders the edit template' do
        discussion = FactoryGirl.create(:discussion, trip_id: @trip.id)
        old_title = discussion.title
        old_body = discussion.body
        put :update,
            trip_id: @trip.id,
            id: discussion.id,
            discussion: {title: '', body: ''}
        discussion.reload
        expect(discussion.title).to eql old_title
        expect(discussion.body).to eql old_body
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the discussion' do
      discussion = FactoryGirl.create(:discussion, trip_id: @trip.id)
      expect {
        delete :destroy,
               trip_id: @trip,
               id: discussion.id
      }.to change(Discussion, :count).by(-1)
    end
    it 'redirects to index' do
      discussion = FactoryGirl.create(:discussion, trip_id: @trip.id)
      delete :destroy,
             trip_id: @trip,
             id: discussion.id
      expect(response).to redirect_to trip_discussions_path @trip
    end
  end
end
