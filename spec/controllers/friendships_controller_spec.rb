require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user)
    @friendships = FactoryGirl.create(:friendship, user_id: @user.id, friend_id: @friend.id)
    sign_in(@user)
  end

  describe 'POST #create' do
    it 'should create a friendship and redirect to the user_path' do
      post :create, user_id: @user.id, friend_id: @friend.id

      expect(response).to redirect_to user_path(@user)
    end
  end

  describe 'DELETE #destroy' do

    it 'should delete a friendship and redirect to current_user' do
      delete :destroy, user_id: @user.id, id: @friendships.id
      expect(response).to redirect_to user_path(@user)
    end

  end

end
