require 'rails_helper'

RSpec.describe DiscussionsController, type: :controller do
  before do
    @owner = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @owner.id)
    @discussion = FactoryGirl.create(:discussion, trip_id: @trip, user_id: @owner)
    FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    #sign_in(@owner)
  end

  describe 'GET #index' do
    get :index
    expect(response).to render_template :index
  end

  describe 'GET #new' do
    get :new
    expect(response).to render_template :new
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new discussion' do
        expect {
          post :create, discussion: FactoryGirl.attributes_for(:discussion), trip: @trip, user: @user
        }.to change(Discussion, :count).by(1)
        expect(response).to redirect_to Discussion.last
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t create a new discussion' do
        expect {
          post :create, discussion: { title: '', body: ''}, trip: @trip, user: @user
        }.to change(Discussion, :count).by(0)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    get :edit, id: @discussion
    expect(response).to render_template :edit
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'locates the requested discussion' do
        put :update, id: @discussion, discussion: FactoryGirl.attributes_for(:discussion)
        expect(assigns(:discussion)).to equal(@discussion)
      end
      it 'changes the discussion attributes and redirects to discussion' do
        title = 'Yolo discussion'
        body = 'Dis discussion is out of ctrl'
        put :update, id: @discussion, discussion: {title: title, body: body}
        @discussion.reload
        expect(@discussion.title).to eql(title)
        expect(@discussion.body).to eql(body)
        expect(response).to render_template :show
      end
    end

    context 'with invalid attributes' do
      it 'locates the requested discussion' do
        put :update, id: @discussion
        expect(assigns(:discussion)).to equal(@discussion)
      end
      it 'doesnt change the discussion attributes and re-renders the edit template' do
        old_title = @discussion.title
        old_body = @discussion.body
        put :update, id: @discussion, discussion: {title: '', body: ''}
        @discussion.reload
        expect(@discussion.title).to eql old_title
        expect(@discussion.body).to eql old_body
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the discussion' do
      expect{
        delete :destroy, id: @discussion
      }.to change(Discussion, :count).by(-1)
    end
    it 'redirects to index' do
      delete :destroy, id: @discussion
      expect(response).to redirect_to :index
    end
  end
end
