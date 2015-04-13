require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @user.id)
    @discussion = FactoryGirl.create(:discussion, trip_id: @trip.id, user_id: @user)
    FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @user.id, participant_role_id: ParticipantRole.owner.id)
    sign_in(@user)
  end



  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new comment' do
        expect {
          post :create,
               comment: FactoryGirl.attributes_for(:comment),
               trip_id: @trip.id,
               discussion_id: @discussion.id,
               format: 'js'
        }.to change(Comment, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end
    context 'with invalid attributes' do
      it 'doesnt create a new comment' do
        expect {
          post :create,
               comment: FactoryGirl.attributes_for(:comment, body: ""),
               discussion_id: @discussion.id,
               trip_id: @trip.id,
               format: 'js'
        }.to change(Discussion, :count).by(0)
      end
    end
  end

end
