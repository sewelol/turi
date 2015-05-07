require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do

  before do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user)

    sign_in(@user)

    @friendRequest = FactoryGirl.create(:request, user_id: @user.id, receiver_id: @friend.id)
  end

  describe 'POST #create' do

    it 'should create a friendship with an existing request and redirect to the user_path' do

      expect {
        post :create, user_id: @user.id, friend_id: @friend.id
      }.to change(Friendship, :count).by(1)
      expect(flash[:notice]).to eql(I18n.t('user_friendship_confirmed'))

      expect(response).to redirect_to user_path(@user)
    end

    it 'should not create a friendship without an existing request and redirect to user_path' do
      expect {
        post :create, user_id: @user.id, friend_id: 5
      }.to change(Friendship, :count).by(0)

      expect(flash[:alert]).to eql(I18n.t('user_friendship_not_confirmed'))
      expect(response).to redirect_to user_path @user
    end


  end

  describe 'DELETE #destroy' do

    it 'should delete a friendship if a friendship exist, and redirect to current_user' do
      @friendship = FactoryGirl.create(:friendship, user_id: @user.id, friend_id: @friend.id)

      expect {
        delete :destroy, user_id: @user, id: @friendship.id
      }.to change(Friendship, :count).by(-1)

      expect(flash[:notice]).to eql(I18n.t('user_friendship_removed'))
      expect(response).to redirect_to user_path(@user)
    end

    it 'should not delete a friendship if a friendship doesnt exist, and redirect to current user' do
      expect {
        delete :destroy, user_id: @user, id: 3
      }.to change(Friendship, :count).by(0)

      expect(flash[:alert]).to eql(I18n.t('user_friendship_not_removed'))
      expect(response).to redirect_to user_path(@user)
    end

  end

end
