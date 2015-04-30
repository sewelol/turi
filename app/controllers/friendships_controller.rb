class FriendshipsController < ApplicationController

  before_action :set_user

  def create
    if params[:request_flag].True
      @friendship = current_user.friendships.build(:friend_id => @user.id)
      flash[:notice] = I18n.t 'user_friendship_confirmed'
    else
      flash[:alert] = I18n.t 'user_request_not_confirmed'
    end
    redirect_to user_path @user
  end

  def destroy
    @friendship = Friendship.where(friend_id: [current_user, params[:id]]).where(user_id: [current_user, params[:id]]).last
    @friendship.destroy
    flash[:notice] = I18n.t 'user_friendship_removed'
    redirect_to current_user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
