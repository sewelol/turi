require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @user.id)
    @discussion = FactoryGirl.create(:discussion, trip_id: @trip.id, user_id: @user)
    FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @user.id, participant_role_id: ParticipantRole.owner.id)
    sign_in(@user)
  end


  describe 'GET #new' do
    it 'renders the new template' do
      get :new,
          trip_id: @trip.id,
          discussion_id: @discussion.id
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new comment' do
        expect {
          post :create,
               comment: FactoryGirl.attributes_for(:comment),
               trip_id: @trip.id,
               discussion_id: @discussion.id
        }.to change(Comment, :count).by(1)
        expect(response).to redirect_to trip_discussion_path(@trip, @discussion)
      end
    end
    context 'with invalid attributes' do
      it 'doesn\'t create a new comment' do
        expect {
          post :create,
               comment: FactoryGirl.attributes_for(:comment, body: ""),
               discussion_id: @discussion.id,
               trip_id: @trip.id
        }.to change(Discussion, :count).by(0)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    it 'render the edit template' do
      comment = FactoryGirl.create(:comment,
                                   discussion_id: @discussion.id)
      get :edit,
          trip_id: @trip.id,
          discussion_id: @discussion.id,
          id: comment
      expect(response).to render_template :edit
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'locates the requested comment' do
        comment = FactoryGirl.create(:comment,
                                     discussion_id: @discussion.id)
        put :update,
            id: comment.id,
            trip_id: @trip.id,
            discussion_id: @discussion.id,
            comment: FactoryGirl.attributes_for(:comment)
        expect(assigns(:comment)).to eql(comment)
      end

      it 'changes the comment attributes and redirects to discussion' do
        comment = FactoryGirl.create(:comment,
                                     discussion_id: @discussion.id)
        body = 'Shes on fire'
        put :update,
            id: comment.id,
            trip_id: @trip.id,
            discussion_id: @discussion.id,
            comment: {body: body}
        comment.reload
        expect(comment.body).to eql(body)
        expect(response).to redirect_to [@trip, @discussion]
      end
    end

    context 'with invalid attributes' do
      it 'locates the requested comment' do
        comment = FactoryGirl.create(:comment,
                                     discussion_id: @discussion.id)
        put :update,
            trip_id: @trip.id,
            discussion_id: @discussion.id,
            id: comment.id,
            comment: {body: ""}
        expect(assigns(:comment)).to eql(comment)
      end

      it 'doesn\'t change the discussion attributes and re-renders the edit template' do
        comment = FactoryGirl.create(:comment,
                                     discussion_id: @discussion.id)
        old_body = comment.body
        put :update,
            trip_id: @trip.id,
            discussion_id: @discussion.id,
            id: comment,
            comment: {body: ''}
        comment.reload
        expect(comment.body).to eql old_body
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the discussion' do
      comment = FactoryGirl.create(:comment,
                                   discussion_id: @discussion.id)
      expect {
        delete :destroy,
               trip_id: @trip.id,
               discussion_id: @discussion.id,
               id: comment.id
      }.to change(Comment, :count).by(-1)
    end

    it 'redirect to discussion' do
      comment = FactoryGirl.create(:comment,
                                   discussion_id: @discussion.id)
      delete :destroy,
             trip_id: @trip.id,
             discussion_id: @discussion.id,
             id: comment
      expect(response).to redirect_to [@trip, @discussion]
    end
  end
end
