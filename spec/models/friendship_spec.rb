require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'friendship' do
  before do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user)
  end

    it 'friends cant be added twice' do
      expect(
        Friendship.create(:user_id => @user.id, :friend_id => @friend.id)
      ).to be_valid
      expect{
        Friendship.create(:user_id => @user.id, :friend_id => @friend.id)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'people who add you, are added to your friend list' do
      expect(
          Friendship.create(:user_id => @user.id, :friend_id => @friend.id)
      ).to be_valid
      expect(
          Friendship.create(:user_id => @friend.id, :friend_id => @user.id)
      ).to be_valid
    end
  end
end
