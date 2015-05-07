class FriendshipsController < ApplicationController

  before_action :set_user

  def create
    pp "params are: #{params}"

    exist = Friendship.request_exists(params[:user_id], params[:friend_id])
    if exist
      @friendship = current_user.friendships.build(friend_id: params[:friend_id])
      if @friendship.save
        flash[:notice] = I18n.t 'user_friendship_confirmed'
      else
        flash[:alert] = t('user_friendship_not_confirmed')
      end
    else
      flash[:alert] = I18n.t 'user_friendship_not_confirmed'
    end
    redirect_to user_path @user
  end

  def destroy
    exist = Friendship.friendship_exists(params[:user_id], params[:friend_id])
    @friendship = Friendship.where(friend_id: [current_user, params[:id]]).where(user_id: [current_user, params[:id]]).last
    @friendship = Friendship.where
    @friendship.destroy
    flash[:notice] = I18n.t 'user_friendship_removed'
    redirect_to current_user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
