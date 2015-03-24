class FriendshipsController < ApplicationController

  before_action :set_user

  def create
    @friendship = current_user.friendships.build(:friend_id => @user.id)
    if @friendship.save
      flash[:notice] = "Added friend."
      redirect_to user_path @user
    else
      flash[:notice] = "Unable to add friend."
      redirect_to user_path @user
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Removed friend."
    redirect_to current_user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end


end
