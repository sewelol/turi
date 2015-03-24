class FriendshipsController < ApplicationController

  before_action :set_user

  def create
    @friendship = current_user.friendships.build(:friend_id => @user.id)
    if @friendship.save
      flash[:notice] = I18n.t 'user_friendship_added'
      redirect_to user_path @user
    else
      flash[:notice] = I18n.t 'user_frienship_not_added'
      redirect_to user_path @user
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = I18n.t 'user_friendship_removed'
    redirect_to current_user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end


end
